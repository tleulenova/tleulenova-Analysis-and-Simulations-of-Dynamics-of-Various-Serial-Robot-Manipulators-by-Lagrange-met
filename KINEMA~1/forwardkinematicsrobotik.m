syms L1 L2  Q1 Q2 D1 D2
alphaa=[0,0]; % this is the alpha value for all  the link
a=[L1,L2]; % Length of the Link
d=[D1,D2]; %Offset
Q=[Q1,Q2]; % joint angle variation
%%Transformation Matrices
for i=1:2
    switch i
        case 1
            T01= [cos(Q(1,i)),-sin(Q(1,i)),0,a(1,i);sin(Q(1,i))*cos(alphaa(1,i)),cos(Q(1,i))*cos(alphaa(1,i)),-sin(alphaa(1,i)),-d(1,i)*sin(alphaa(1,i));sin(Q(1,i))*sin(alphaa(1,i)),cos(Q(1,i))*sin(alphaa(1,i)),cos(alphaa(1,i)),d(1,i)*cos(alphaa(1,i));0,0,0,1];
        case 2
            T12= [cos(Q(1,i)),-sin(Q(1,i)),0,a(1,i);sin(Q(1,i))*cos(alphaa(1,i)),cos(Q(1,i))*cos(alphaa(1,i)),-sin(alphaa(1,i)),-d(1,i)*sin(alphaa(1,i));sin(Q(1,i))*sin(alphaa(1,i)),cos(Q(1,i))*sin(alphaa(1,i)),cos(alphaa(1,i)),d(1,i)*cos(alphaa(1,i));0,0,0,1];
    end
end
T01 % first link with respect to base
T12 % second link with respect first link
T02= T01*T12

