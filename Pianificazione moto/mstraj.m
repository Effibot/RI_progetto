%MSTRAJ Multi-segment multi-axis trajectory
%
% TRAJ = MSTRAJ(WP, QDMAX, TSEG, Q0, DT, TACC, OPTIONS) is a trajectory
% (KxN) for N axes moving simultaneously through M segment.  Each segment
% is linear motion and polynomial blends connect the segments.  The axes
% start at Q0 (1xN) and pass through M-1 via points defined by the rows of
% the matrix WP (MxN), and finish at the point defined by the last row of WP.
% The  trajectory matrix has one row per time step, and one column per
% axis.  The number of steps in the trajectory K is a function of the
% number of via points and the time or velocity limits that apply.
%
% - WP (MxN) is a matrix of via points, 1 row per via point, one column 
%   per axis.  The last via point is the destination.
% - QDMAX (1xN) are axis speed limits which cannot be exceeded,
% - TSEG (1xM) are the durations for each of the K segments
% - Q0 (1xN) are the initial axis coordinates
% - DT is the time step
% - TACC (1x1) is the acceleration time used for all segment transitions
% - TACC (1xM) is the acceleration time per segment, TACC(i) is the acceleration 
%   time for the transition from segment i to segment i+1.  TACC(1) is also 
%   the acceleration time at the start of segment 1.
%
% TRAJ = MSTRAJ(WP, QDMAX, TSEG, [], DT, TACC, OPTIONS) as above but the
% initial coordinates are taken from the first row of WP.
%
% TRAJ = MSTRAJ(WP, QDMAX, Q0, DT, TACC, QD0, QDF, OPTIONS) as above
% but additionally specifies the initial and final axis velocities (1xN).
%
% Options::
% 'verbose'    Show details.
%
% Notes::
% - Only one of QDMAX or TSEG can be specified, the other is set to [].
% - If no output arguments are specified the trajectory is plotted.
% - The path length K is a function of the number of via points, Q0, DT
%   and TACC.
% - The final via point P(end,:) is the destination.
% - The motion has M segments from Q0 to P(1,:) to P(2,:) ... to P(end,:).
% - All axes reach their via points at the same time.
% - Can be used to create joint space trajectories where each axis is a joint
%   coordinate.
% - Can be used to create Cartesian trajectories where the "axes"
%   correspond to translation and orientation in RPY or Euler angle form.
% - If qdmax is a scalar then all axes are assumed to have the same
%   maximum speed.
%
% See also MTRAJ, LSPB, CTRAJ.

% Copyright (C) 1993-2017, by Peter I. Corke
%
% This file is part of The Robotics Toolbox for MATLAB (RTB).
% 
% RTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% RTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with RTB.  If not, see <http://www.gnu.org/licenses/>.
%
% http://www.petercorke.com

function [TG, t, info]  = mstraj(segments, qdmax, tsegment, q0, dt, Tacc, varargin)

    if isempty(q0)
        q0 = segments(1,:);
        segments = segments(2:end,:);
    end
    
    assert(size(segments,2) == size(q0,2), 'RTB:mstraj:badarg', 'WP and Q0 must have same number of columns');
    assert(xor(~isempty(qdmax), ~isempty(tsegment)), 'RTB:mstraj:badarg', 'Must specify either qdmax or tsegment, but not both');
    if isempty(qdmax)
        assert(length(tsegment) == size(segments,1), 'RTB:mstraj:badarg', 'Length of TSEG does not match number of segments');
    end
    if isempty(tsegment)
        if length(qdmax) == 1
            % if qdmax is a scalar assume all axes have the same speed
            qdmax = repmat(qdmax, 1, size(segments,2));
        end
        assert(length(qdmax) == size(segments,2), 'RTB:mstraj:badarg', 'Length of QDMAX does not match number of axes'); 
    end
    
    ns = size(segments,1);
    nj = size(segments,2);

    [opt,args] = tb_optparse([], varargin);

    if length(args) > 0
        qd0 = args{1};
    else
        qd0 = zeros(1, nj);
    end
    if length(args) > 1
        qdf = args{2};
    else
        qdf = zeros(1, nj);
    end

    % set the initial conditions
    q_prev = q0;
    qd_prev = qd0;

    clock = 0;      % keep track of time
    arrive = [];    % record planned time of arrival at via points

    tg = [];
    taxis = [];

    for seg=1:ns
        if opt.verbose
            fprintf('------------------- segment %d\n', seg);
        end

        % set the blend time, just half an interval for the first segment

        if length(Tacc) > 1
            tacc = Tacc(seg);
        else
            tacc = Tacc;
        end

        tacc = ceil(tacc/dt)*dt;
        tacc2 = ceil(tacc/2/dt) * dt;
        if seg == 1
            taccx = tacc2;
        else
            taccx = tacc;
        end

        % estimate travel time
        %    could better estimate distance travelled during the blend
        q_next = segments(seg,:);    % current target
        dq = q_next - q_prev;    % total distance to move this segment

        %% probably should iterate over the next section to get qb right...
        % while 1
        %   qd_next = (qnextnext - qnext)
        %   tb = abs(qd_next - qd) ./ qddmax;
        %   qb = f(tb, max acceleration)
        %   dq = q_next - q_prev - qb
        %   tl = abs(dq) ./ qdmax;

        if ~isempty(qdmax)
            % qdmax is specified, compute slowest axis

            qb = taccx * qdmax / 2;        % distance moved during blend
            tb = taccx;

            % convert to time
            tl = abs(dq) ./ qdmax;
            %tl = abs(dq - qb) ./ qdmax;
            tl = ceil(tl/dt) * dt;

            % find the total time and slowest axis
            tt = tb + tl;
            [tseg,slowest] = max(tt);
            
            info(seg).slowest = slowest;
            info(seg).segtime = tseg;
            info(seg).axtime = tt;
            info(seg).clock = clock;

            % best if there is some linear motion component
            if tseg <= 2*tacc
                tseg = 2 * tacc;
            end
        elseif ~isempty(tsegment)
            % segment time specified, use that
            tseg = tsegment(seg);
            slowest = NaN;
        end

        % log the planned arrival time
        arrive(seg) = clock + tseg;
        if seg > 1
            arrive(seg) = arrive(seg) + tacc2;
        end

        if opt.verbose
            fprintf('seg %d, slowest axis %d, time required %.4g\n', ...
                seg, slowest, tseg);
        end

        %% create the trajectories for this segment

        % linear velocity from qprev to qnext
        qd = dq / tseg;

        % add the blend polynomial
        qb = jtraj(q0, q_prev+tacc2*qd, 0:dt:taccx, qd_prev, qd);
        tg = [tg; qb(2:end,:)];

        clock = clock + taccx;     % update the clock

        % add the linear part, from tacc/2+dt to tseg-tacc/2
        for t=tacc2+dt:dt:tseg-tacc2
            s = t/tseg;
            q0 = (1-s) * q_prev + s * q_next;       % linear step
            tg = [tg; q0];
            clock = clock + dt;
        end

        q_prev = q_next;    % next target becomes previous target
        qd_prev = qd;
    end
    % add the final blend
    qb = jtraj(q0, q_next, 0:dt:tacc2, qd_prev, qdf);
    tg = [tg; qb(2:end,:)];
    info(seg+1).segtime = tacc2;
    info(seg+1).clock = clock;

    % plot a graph if no output argument
    if nargout == 0
        t = (0:size(tg,1)-1)'*dt;
        clf
        plot(t, tg, '-o');
        hold on
        plot(arrive, segments, 'bo', 'MarkerFaceColor', 'k');
        hold off
        grid
        xlabel('time');
        xaxis(t(1), t(end))
        return
    end
    if nargout > 0
        TG = tg;
    end
    if nargout > 1
        t = (0:numrows(tg)-1)'*dt;
    end
    if nargout > 2
        infout = info;
    end

    %OPTPARSE Standard option parser for Toolbox functions
%
% OPTOUT = TB_OPTPARSE(OPT, ARGLIST) is a generalized option parser for
% Toolbox functions.  OPT is a structure that contains the names and
% default values for the options, and ARGLIST is a cell array containing
% option parameters, typically it comes from VARARGIN.  It supports options
% that have an assigned value, boolean or enumeration types (string or
% int).
%
% [OPTOUT,ARGS] = TB_OPTPARSE(OPT, ARGLIST) as above but returns all the
% unassigned options, those that don't match anything in OPT, as a cell
% array of all unassigned arguments in the order given in ARGLIST.
%
% [OPTOUT,ARGS,LS] = TB_OPTPARSE(OPT, ARGLIST) as above but if any
% unmatched option looks like a MATLAB LineSpec (eg. 'r:') it is placed in LS rather
% than in ARGS.
%
% [OBJOUT,ARGS,LS] = TB_OPTPARSE(OPT, ARGLIST, OBJ) as above but properties
% of OBJ with matching names in OPT are set.
%
% The software pattern is:
%
%         function myFunction(a, b, c, varargin)
%            opt.foo = false;
%            opt.bar = true;
%            opt.blah = [];
%            opt.stuff = {};
%            opt.choose = {'this', 'that', 'other'};
%            opt.select = {'#no', '#yes'};
%            opt.old = '@foo';
%            opt = tb_optparse(opt, varargin);
%
% Optional arguments to the function behave as follows:
%   'foo'              sets opt.foo := true
%   'nobar'            sets opt.foo := false
%   'blah', 3          sets opt.blah := 3
%   'blah',{x,y}       sets opt.blah := {x,y}
%   'that'             sets opt.choose := 'that'
%   'yes'              sets opt.select := 2 (the second element)
%   'stuff', 5         sets opt.stuff to {5}
%   'stuff', {'k',3}   sets opt.stuff to {'k',3}
%   'old'              synonym, is the same as the option foo
%
% and can be given in any combination.
%
% If neither of 'this', 'that' or 'other' are specified then opt.choose := 'this'.
% Alternatively if:
%        opt.choose = {[], 'this', 'that', 'other'};
% then if neither of 'this', 'that' or 'other' are specified then opt.choose := [].
%
% If neither of 'no' or 'yes' are specified then opt.select := 1.
%
%
% The return structure is automatically populated with fields: verbose and
% debug.  The following options are automatically parsed:
%   'verbose'       sets opt.verbose := true
%   'verbose=2'     sets opt.verbose := 2 (very verbose)
%   'verbose=3'     sets opt.verbose := 3 (extremeley verbose)
%   'verbose=4'     sets opt.verbose := 4 (ridiculously verbose)
%   'debug', N      sets opt.debug := N
%   'showopt'       displays opt and arglist
%   'setopt',S      sets opt := S, if S.foo=4, and opt.foo is present, then
%                   opt.foo is set to 4.
%
% The allowable options are specified by the names of the fields in the
% structure OPT.  By default if an option is given that is not a field of 
% OPT an error is declared.  
%
% Notes::
% - That the enumerator names must be distinct from the field names.
% - That only one value can be assigned to a field, if multiple values
%   are required they must placed in a cell array.
% - If the option is seen multiple times the last (rightmost) instance applies.
% - To match an option that starts with a digit, prefix it with 'd_', so
%   the field 'd_3d' matches the option '3d'.
% - Any input argument or element of the opt struct can be a string instead
%   of a char array.

%## utility

% Copyright (C) 1993-2019 Peter I. Corke
%
% This file is part of The Spatial Math Toolbox for MATLAB (SMTB).
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
% of the Software, and to permit persons to whom the Software is furnished to do
% so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
% FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
% COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
% IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
% CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% https://github.com/petercorke/spatial-math

% Modifications by Joern Malzahn to support classes in addition to structs
%JTRAJ Compute a joint space trajectory
%
% [Q,QD,QDD] = JTRAJ(Q0, QF, M) is a joint space trajectory Q (MxN) where the joint
% coordinates vary from Q0 (1xN) to QF (1xN).  A quintic (5th order) polynomial is used 
% with default zero boundary conditions for velocity and acceleration.  
% Time is assumed to vary from 0 to 1 in M steps.  Joint velocity and 
% acceleration can be optionally returned as QD (MxN) and QDD (MxN) respectively.
% The trajectory Q, QD and QDD are MxN matrices, with one row per time step,
% and one column per joint.
%
% [Q,QD,QDD] = JTRAJ(Q0, QF, M, QD0, QDF) as above but also specifies
% initial QD0 (1xN) and final QDF (1xN) joint velocity for the trajectory.
%
% [Q,QD,QDD] = JTRAJ(Q0, QF, T) as above but the number of steps in the
% trajectory is defined by the length of the time vector T (Mx1).
%
% [Q,QD,QDD] = JTRAJ(Q0, QF, T, QD0, QDF) as above but specifies initial and 
% final joint velocity for the trajectory and a time vector.
%
% Notes::
% - When a time vector is provided the velocity and acceleration outputs
%   are scaled assumign that the time vector starts at zero and increases
%   linearly.
%
% See also QPLOT, CTRAJ, SerialLink.jtraj.




% Copyright (C) 1993-2017, by Peter I. Corke
%
% This file is part of The Robotics Toolbox for MATLAB (RTB).
% 
% RTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% RTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with RTB.  If not, see <http://www.gnu.org/licenses/>.
%
% http://www.petercorke.com

function [qt,qdt,qddt] = jtraj(q0, q1, tv, qd0, qd1)
    if length(tv) > 1
        tscal = max(tv);
        t = tv(:)/tscal;
    else
        tscal = 1;
        t = (0:(tv-1))'/(tv-1); % normalized time from 0 -> 1
    end

    q0 = q0(:);
    q1 = q1(:);

    if nargin == 3
        qd0 = zeros(size(q0));
        qd1 = qd0;
    elseif nargin == 5
        qd0 = qd0(:);
        qd1 = qd1(:);
    else
        error('incorrect number of arguments')
    end

    % compute the polynomial coefficients
    A = 6*(q1 - q0) - 3*(qd1+qd0)*tscal;
    B = -15*(q1 - q0) + (8*qd0 + 7*qd1)*tscal;
    C = 10*(q1 - q0) - (6*qd0 + 4*qd1)*tscal;
    E = qd0*tscal; % as the t vector has been normalized
    F = q0;

    tt = [t.^5 t.^4 t.^3 t.^2 t ones(size(t))];
    c = [A B C zeros(size(A)) E F]';
    
    qt = tt*c;

    % compute optional velocity
    if nargout >= 2
        c = [ zeros(size(A)) 5*A 4*B 3*C  zeros(size(A)) E ]';
        qdt = tt*c/tscal;
    end

    % compute optional acceleration
    if nargout == 3
        c = [ zeros(size(A))  zeros(size(A)) 20*A 12*B 6*C  zeros(size(A))]';
        qddt = tt*c/tscal^2;
    end
function [opt,others,ls] = tb_optparse(in, argv, cls)

    if nargin == 1
        argv = {};
    end

    if nargin < 3
        cls = [];
    end
    
    assert(iscell(argv), 'SMTB:tboptparse:badargs', 'input must be a cell array');
    
    if ~verLessThan('matlab', '9.1')
        % is only appeared in 2016b
        
        % handle new style string inputs
        % quick and dirty solution is to convert any string to a char array and
        % then carry on as before
        
        % convert any passed strings to character arrays
        for i=1:length(argv)
            if isstring(argv{i}) && length(argv{i}) == 1
                argv{i} = char(argv{i});
            end
        end
        % convert strings in opt struct to character arrays
        if ~isempty(in)
            fields = fieldnames(in);
            for i=1:length(fields)
                field = fields{i};
                % simple string elements
                if isstring(in.(field))
                    in.(field) = char(in.(field));
                end
                % strings in cell array elements
                if iscell(in.(field))
                    in.(field) = cellfun(@(x) char(x), in.(field), 'UniformOutput', false);
                end
            end
        end
    end

    %% parse the arguments

    arglist = {};

    argc = 1;
    opt = in;
    
    if ~isfield(opt, 'verbose')
        opt.verbose = false;
    end
    if ~isfield(opt, 'debug')
        opt.debug = 0;
    end

    showopt = false;
    choices = [];

    while argc <= length(argv)
        % index over every passed option
        option = argv{argc};
        assigned = false;
        
        if ischar(option)

            switch option
            % look for hardwired options
            case 'verbose'
                opt.verbose = true;
                assigned = true;
            case 'verbose=2'
                opt.verbose = 2;
                assigned = true;
            case 'verbose=3'
                opt.verbose = 3;
                assigned = true;
            case 'verbose=4'
                opt.verbose = 4;
                assigned = true;
            case 'debug'
                opt.debug = argv{argc+1};
                argc = argc+1;
                assigned = true;
            case 'setopt'
                new = argv{argc+1};
                argc = argc+1;
                assigned = true;

                % copy matching field names from new opt struct to current one
                for f=fieldnames(new)'
                    if isfield(opt, f{1})
                        opt.(f{1}) = new.(f{1});
                    end
                end
            case 'showopt'
                showopt = true;
                assigned = true;

            otherwise
                % does the option match a field in the opt structure?
%                 if isfield(opt, option) || isfield(opt, ['d_' option])
%                if any(strcmp(fieldnames(opt),option)) || any(strcmp(fieldnames(opt),))

                 % look for a synonym, only 1 level of indirection is supported
                 if isfield(opt, option) && ischar(opt.(option)) && length(opt.(option)) > 1 && opt.(option)(1) == '@'
                     option = opt.(option)(2:end);
                 end
                 
                 % now deal with the option
                 if isfield(opt, option) || isfield(opt, ['d_' option]) || isprop(opt, option)
                    
                    % handle special case if we we have opt.d_3d, this
                    % means we are looking for an option '3d'
                    if isfield(opt, ['d_' option]) || isprop(opt, ['d_' option])
                        option = ['d_' option];
                    end
                    
                    %** BOOLEAN OPTION
                    val = opt.(option);
                    if islogical(val)
                        % a logical variable can only be set by an option
                        opt.(option) = true;
                    else
                        %** OPTION IS ASSIGNED VALUE FROM NEXT ARG
                        % otherwise grab its value from the next arg
                        try
                            opt.(option) = argv{argc+1};
                            if iscell(in.(option)) && isempty(in.(option))
                                % input was an empty cell array
                                if ~iscell(opt.(option))
                                    % make it a cell
                                    opt.(option) = { opt.(option) };
                                end
                            end
                        catch me
                            if strcmp(me.identifier, 'MATLAB:badsubscript')
                                error('SMTB:tboptparse:badargs', 'too few arguments provided for option: [%s]', option);
                            else
                                rethrow(me);
                            end
                        end
                        argc = argc+1;
                    end
                    assigned = true;
                elseif length(option)>2 && strcmp(option(1:2), 'no') && isfield(opt, option(3:end))
                    %* BOOLEAN OPTION PREFIXED BY 'no'
                    val = opt.(option(3:end));
                    if islogical(val)
                        % a logical variable can only be set by an option
                        opt.(option(3:end)) = false;
                        assigned = true;
                    end
                else
                    % the option doesn't match a field name
                    % let's assume it's a choice type
                    %     opt.choose = {'this', 'that', 'other'};
                    %
                    % we need to loop over all the passed options and look
                    % for those with a cell array value
                    for field=fieldnames(opt)'
                        val = opt.(field{1});
                        if iscell(val)
                            for i=1:length(val)
                                if isempty(val{i})
                                    continue;
                                end
                                % if we find a match, put the final value
                                % in the temporary structure choices
                                %
                                % eg. choices.choose = 'that'
                                %
                                % so that we can process input of the form
                                %
                                %  'this', 'that', 'other'
                                %
                                % which should result in the value 'other'
                                if strcmp(option, val{i})
                                    choices.(field{1}) = option;
                                    assigned = true;
                                    break;
                                elseif val{i}(1) == '#' && strcmp(option, val{i}(2:end))
                                    choices.(field{1}) = i;
                                    assigned = true;
                                    break;
                                end
                            end
                            if assigned
                                break;
                            end
                        end
                    end
                end
            end % switch
        end
        if ~assigned
            % non matching options are collected
            if nargout >= 2
                arglist = [arglist argv(argc)];
            else
                if ischar(argv{argc})
                    error(['unknown options: ' argv{argc}]);
                end
            end
        end
        
        argc = argc + 1;
    end % while
    
    % copy choices into the opt structure
    if ~isempty(choices)
        for field=fieldnames(choices)'
            opt.(field{1}) = choices.(field{1});
        end
    end
 
    % if enumerator value not assigned, set the default value
    if ~isempty(in)
        for field=fieldnames(in)'
            if iscell(in.(field{1})) && ~isempty(in.(field{1})) && iscell(opt.(field{1}))
                val = opt.(field{1});
                if isempty(val{1})
                    opt.(field{1}) = val{1};
                elseif val{1}(1) == '#'
                    opt.(field{1}) = 1;
                else
                    opt.(field{1}) = val{1};
                end
            end
        end
    end
    
    % opt is now complete
                        
    if showopt
        fprintf('Options:\n');
        opt
        arglist
    end

    % however if a class was passed as a second argument, set its properties
    % according to the fields of opt
    if ~isempty(cls)

        for field=fieldnames(opt)'
            if isprop(cls, field{1})
                cls.(field{1}) = opt.(field{1});
            end
        end
        
        opt = cls;
    end
    
    if nargout == 3
        % check to see if there is a valid linespec floating about in the
        % unused arguments
        ls = [];
        for i=1:length(arglist)
            s = arglist{i};
            if ~ischar(s)
                continue;
            end
            % get color
            [b,e] = regexp(s, '[rgbcmywk]');
            s2 = s(b:e);
            s(b:e) = [];
            
            % get line style
            [b,e] = regexp(s, '(--)|(-.)|-|:');
            s2 = [s2 s(b:e)];
            s(b:e) = [];
            
            % get marker style
            [b,e] = regexp(s, '[o\+\*\.xsd\^v><ph]');
            s2 = [s2 s(b:e)];
            s(b:e) = [];
            
            % found one
            if length(s) == 0
                ls = arglist{i};
                arglist(i) = [];
                break;
            end
        end
        others = arglist;
        if isempty(ls)
            ls = {};
        else
            ls = {ls};
        end
    elseif nargout == 2
        others = arglist;
    end