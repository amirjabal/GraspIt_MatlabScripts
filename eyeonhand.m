Gt = [700 240 152;700 200 152; 700 40 130; 700 0 130; 700 -150 90;700 -210 90; ...
    800 240 152;800 200 152; 800 40 130; 800 0 130; 800 -150 90;800 -210 90; ...
    800 240 152;800 200 152; 800 60 90; 800 0 90; 800 -150 130;800 -190 130; ...
    800 240 152;800 200 152; 700 60 90; 700 0 90; 700 -150 130;700 -190 130];

Test = [640 213 117;640 172 117;636 26 93;635 -12 93;642 -158 47;638 -213 46;...
    734 207 121;737 167 118;736 27 96;736 -16 94;737 -160 46;735 -225 45;...
    735 210 118;736 168 120;735 54 52;733 -13 50;737 -165 93;738 -206 91;...
    734 206 120;736 167 120;636 52 50;635 -8  50;637 -163 90;638 -205 88];


pos = [200.4400   -0.5700  114.6600];
Gt(:,1) = Gt(:,1)-pos(1);
Gt(:,2) = Gt(:,2)-pos(2);
Gt(:,3) = Gt(:,3)-pos(3);

Test(:,1) = Test(:,1)-pos(1);
Test(:,2) = Test(:,2)-pos(2);
Test(:,3) = Test(:,3)-pos(3);

% Gt-Test;

T1 = [   63.5000   18.1250   37.5417];
Test2(:,1) = Test(:,1) + T1(1);
Test2(:,2) = Test(:,2) + T1(2);
Test2(:,3) = Test(:,3) + T1(3);


figure;
plot3(Gt(:,1),Gt(:,2),Gt(:,3),'*')
hold on;
plot3(Test2(:,1),Test2(:,2),Test2(:,3),'o')


Y = Gt';
X = Test';
% X(4,:) = ones(1,24);
% n = 20 ;
% p = 3 ;
% q = 3 ;
% Cost = zeros(0,0);
% W = ones(3,4);
% stop = 0;
% m = length(Y);
% CH = zeros;
% siz = size(W);
% grad = W;
% iter = 0;
% tic;
% S = 0;
% while stop == 0
% % for i = 1:10000
%     iter = iter+1;
%     F = (W*X-Y);
%     for ii=1:siz(1)
%         for j = 1:siz(2)
%             grad(ii,j) = sum(F(ii,:).*X(j,:));
%         end
%     end
%     step = 0.00000001;
%     grad;
%     W = W - step*grad;
%     Cost = (norm(Y-W*X))^2;
%     CH = [CH,Cost];
%     stopv = (CH(length(CH))-CH(length(CH)-1))/CH(length(CH));
%     if abs(stopv)<0.001
%         stop = 1;
%     end
% end
% R = W(:,1:3)
% T = W(:,4)
% figure
% plot(CH)
% 
% TT = W*Y
% figure;
% plot3(Gt(:,1),Gt(:,2),Gt(:,3),'*')
% hold on;
% plot3(TT(:,1),TT(:,2),TT(:,3),'o')


X(4,:) = ones(1,24);
n = 24 ; 
p = 3  ;  
q = 3 ;   
Cost = zeros(0,0);
W = ones(3,4);

stop = 0;
m = length(Y); 
CH = zeros;
siz = size(W);
grad = W; 
iter = 0;
tic;
S = 0;
while stop == 0
% for i  = 1:10000
    iter = iter+1;
     F = (W*X-Y);
    for ii=1:siz(1)
        for j = 1:siz(2)
        grad(ii,j) = sum(F(ii,:).*X(j,:));
        end
    end 
    step = 0.000001;
    W = W - step*grad;
    Cost = (norm(Y-W*X))^2;
    CH = [CH,Cost];
    stopv = (CH(length(CH))-CH(length(CH)-1))/CH(length(CH));
    if abs(stopv)<0.001
        stop = 1;
    end
end
% toc;
% figure(1)
% plot(CH(2:length(CH)))
% iter
% 
A = Y;
BB = X;
BB(4,:) = ones(1,24);
AA = W*BB;
A2 = AA(1:3,:);
figure()
plot3(A(1,:),A(2,:),A(3,:),'*')
hold on
plot3(A2(1,:),A2(2,:),A2(3,:),'o')%plot 

R = W(:,1:3)
T = W(:,4)