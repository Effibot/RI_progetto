function curve = pathfind(nodeList, idList, Aint, Amid, obsList)
% nodeList: lista di nodi che compongono il path
% Aint: matrice n x n x 2 di componenti [x,y]
% costruisco sequenza di punti in cui far passare il path
dimPath = size(idList,2);
nPoints = double.empty(0,2);
for i = 1:dimPath -1
    node = findobj(nodeList, 'id', idList(i));
    next = findobj(nodeList, 'id', idList(i+1));
    if (~isempty(node) || ~isempty(next))
        if isempty(ismember(nPoints,node.bc,'rows'))
            nPoints(end+1,:) = node.bc;
        end
        %             nPoints(end+1,:) = Amid(node.id,next.id,:);
        %             nPoints(end+1,:) = Aint(node.id,next.id,:);
        nPoints(end+1,:) = selectPoint(node, next, Amid, Aint, obsList);
        nPoints(end+1,:) = next.bc;
    end
end
% individuo potenziali angoli retti
offset = 3;
for i = 1:size(nPoints,1)-2
    if nPoints(i,1) == nPoints(i+1,1) &&...
            nPoints(i+1,2) == nPoints(i+2,2) || ...
            nPoints(i,2) == nPoints(i+1,2) && ...
            nPoints(i+1,1) == nPoints(i+2,1)
        % ho trovato un angolo retto
        if nPoints(i,1) < nPoints(i+2,1)
            % angolo verso il basso
            nPoints(i+1,1) = nPoints(i+1,1) + offset;
        else
            % angolo verso l'alto
            nPoints(i+1,1) = nPoints(i+1,1) - offset;
        end
        if nPoints(i,2) < nPoints(i+2,2)
            % angolo da sinistra
            nPoints(i+1,2) = nPoints(i+1,2) - offset;
        else
            % angolo da destra
            nPoints(i+1,2) = nPoints(i+1,2) + offset;
        end
    end
end
dim = length(nPoints);
nPoints = interparc(dim,nPoints(:,1),nPoints(:,2),'linear');
tstart = 0;
tend = dim-1;
stepsize = 0.001;
time = tstart:stepsize:floor(tend/2);
time = linspace(tstart,floor(tend/2),(dim-1)*500);
x = nPoints(:,1);
y= nPoints(:,2);
[qx,qxd,qxdd]=smoothSpline(dim,x,time,tstart);
% subplot(4,2,1)
% plot(qx,'b')
% 
% subplot(4,2,3)
% plot(qxd,'c')
% 
% subplot(4,2,5)
% plot(qxdd,'m')
[qy,qyd,qydd]=smoothSpline(dim,y,time,tstart);
% subplot(4,2,2)
% plot(qy,'b')
% 
% subplot(4,2,4)
% plot(qyd,'c')
% 
% subplot(4,2,6)
% plot(qydd,'m')
% 
% subplot(4,2,[7 8])
% plot(qx,qy,'k')
curve = [qy;qx]';
% Risolvo equazioni per calcolare le spline
%     k = 100;    % sampling factor
%     lengthCurve = arclength(nPoints(:,2),nPoints(:,1),'makima');
%
%     density = lengthCurve/size(nPoints,1);
%      pt = linspace(0,1,floor(k*density));
% pt=1000;
%     [q,dt,foft,step,spld]=interparc(pt,nPoints(:,2)',nPoints(:,1)','makima');
%
%     curve=q;
%% Controllo errore sulle distanze tra un punto e il successivo
%         q=curvspace(q,size(q,1));
% q;
%     dist = norm(q(1,:)-q(2,:));
%     dnom=dist;
%     for i = 2:size(q,1)-1
%         dist = [dist;norm(q(i,:)-q(i+1,:))];
%
%     end
%
% %Derivatives
% dxdt = diff(q(:,1),[],1);
% dydt=diff(q(:,2),[],1);
%     a=[dxdt,dydt];
% modV=norm(a(1,:)-a(2,:));
% modVn=modV;
% for ii = 2:size(a,1)-1
% modV = [modV;norm(a(ii,:)-a(ii+1,:))];
% end
% bbb=abs(modV-modVn)
end

function point = selectPoint(node, next, Amid, Aint, obsList)

pointInt = [Aint(node.id, next.id,1), Aint(node.id, next.id,2)];
pointMid = [Amid(node.id, next.id,1), Amid(node.id, next.id,2)];

[closestObstInt, minDistInt] = findClosestObs(obsList, pointInt);
[closestObstMid, minDistMid] = findClosestObs(obsList, pointMid);

if isequal(closestObstMid, closestObstInt)
    if minDistInt >= minDistMid
        point = pointInt;
    else
        point = pointMid;
    end
else
    point = (pointInt+pointMid)/2;
end
end

function [q,qd,qdd] = smoothSpline(dim,nPoints,time,tstart)
q = double.empty;
qd = double.empty;
qdd = double.empty;
vi=0;
for i = 2:dim
%     interval = time((i-2)*100*floor(dim/2)+1:(i-1)*100*floor(dim/2));
interval = time((i-2)*500+1:(i-1)*500);
    pi = nPoints(i-1,:);
    pf = nPoints(i,:);
    ti = interval(1);
    tf1 = interval(end);


    %     if i==dim
    %         vf=0;
    %     elseif i == 2
    %         vf = Rk1;
    % %     elseif sign(Rk)==sign(Rk1)
    % %         vf = (Rk1+Rk)*(0.5);
    % %
    % %     else
    % %         vf = 0;
    %     end
    for t=interval
        if t ==tstart
            q(end+1)=pi;
            qd(end+1)=0;
            qdd(end+1)=0;
        else
            Rk = (q(end)-pi)/((t-1e-3)-ti);
            Rk1 = (pf-q(end))/(tf1-(t-1e-3));
            if i==dim
                vf =0;
            else
%                 interval1 = time((i-1)*100*floor(dim/2)+1:(i)*100*floor(dim/2));
                interval1 = time((i-1)*500:i*500);
                pf2 = nPoints(i+1,:);
                tf2 = interval1(end);
                Rk = (pf-pi)/(tf1-ti);
                Rk1 = (pf2-pf)/(tf2-tf1);
                if sign(Rk)==sign(Rk1) && i~=2 && i<dim-1
                    vf = (Rk+Rk1)*0.5;
                else
                    vf=0;
                end
            end
            %             A = [
            %                 ti^3 ti^2 ti 1;
            %                 tf1^3 tf1^2 tf1 1;
            %                 3*ti^2 2*ti 1 0;
            %                 3*tf1^2 2*tf1 1 0;
            %                 ];
            A=[ti^5 ti^4 ti^3 ti^2 ti 1;
                tf1^5 tf1^4 tf1^3 tf1^2 tf1 1;
                5*ti^4 4*ti^3 3*ti^2 2*ti 1 0;
                5*tf1^4 4*tf1^3 3*tf1^2 2*tf1 1 0;
                20*ti^3 12*ti^2 6*ti 2 0 0;
                20*tf1^3 12*tf1^2 6*tf1 2 0 0];
            b = [pi;pf;vi;vf;0;0];
            x = inv(A)*b;
            %             s= x(1)*t^3+x(2)*t^2+x(3)*t+x(4);
            %             sdot= 3*x(1)*t^2+2*x(2)*t+x(3);
            s = x(1)*t^5+x(2)*t^4+x(3)*t^3+x(4)*t^2+x(5)*t+x(6);
            sdot = 5*x(1)*t^4+4*x(2)*t^3+3*x(3)*t^2+2*x(4)*t+x(5);
            sddot = 20*x(1)*t^3+12*x(2)*t^2+6*x(3)*t+2*x(4);
            q(end+1)=s;
            qd(end+1)=sdot;
            qdd(end+1)=sddot;

        end

    end
    vi = vf;
    %     ai = sddot;
    %     subplot(4,2,1)
    %     plot(time(1:length(trajectory(:,1))),trajectory(:,1),'b')
    %     subplot(4,2,2)
    %     plot(time(1:length(trajectory(:,1))),trajectory(:,2),'r')
    %     subplot(4,2,3)
    %     plot(time(1:length(trajectory(:,1))),dtrajectory(:,1),'c')
    %     subplot(4,2,4)
    %     plot(time(1:length(trajectory(:,1))),dtrajectory(:,2),'y')
    %     subplot(4,2,5)
    %     plot(time(1:length(trajectory(:,1))),ddtrajectory(:,1),'m')
    %     subplot(4,2,6)
    %     plot(time(1:length(trajectory(:,1))),ddtrajectory(:,2),'g')
    %     subplot(4,2,7)
    %     plot(trajectory(:,1),trajectory(:,2),'b')
end
end

