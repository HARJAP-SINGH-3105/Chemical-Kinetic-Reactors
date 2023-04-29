
user = "Which method -:\n" + ...
    "1. Rate expression\n" + ...
    "2. Discrete points\n";
method = input(user);



if method==2

    C = [0.5 3 1 2 6 10 8 4];
    Cao = [2 5 6 6 11 14 16 24];
    Tau = [30 1 50 8 4 20 20 4];
    R= Tau./(Cao-C);
    ft = fittype('CustomCurveFitFunction(x, a, b, c)');
    f = fit(C(:), R(:), ft);
    coeff = coeffvalues(f);
    k2 = coeff(1,1);
    k3 = coeff(1,2);
    k1 = coeff(1,3);
    figure();
    plot(f,C,R);
    hold on
end

if method==1

    user = "What is the value of K1?\n";
    k1 = input(user);
    user = "What is the value of K2?\n";
    k2 = input(user);
    user = "What is the value of K3?\n";
    k3 = input(user);
   

     
end

user = "What is the lower limit of Ca?\n";
lower = input(user);
user  = "What is the upper limit of Ca?\n";
upper = input(user);
user  = "What is the Flow rate v0?\n";
v0 = input(user);
% lower = 0.1;
% upper = 8;
Xa = (upper - lower)/upper;
% v0 = 0.1;
% k1 = 1;
% k2 = 1;
% k3 = 1;
num = 1;
if method==1
    Ca = linspace(lower,upper);
    rate = k1.*Ca./(1+k2.*Ca+k3.*(Ca.^2)); 
    rate = 1./rate;
    figure();
    plot(Ca,rate,'r','LineWidth',2);
    hold on
    axis([0 upper 0 max(rate)+5]);
    title("1/Rate vs Concentration");
    xlabel('Concentration'); ylabel('1/-rA');  
end


while(num~=-1)
    % Asking from user which action wants to execute
    disp('Select the corresponding number for respective system');
    disp('1  Single PFR');
    disp('2  Single MFR');
    disp('3  Two stirred tanks of any size');
    disp('4  MFR and PFR combination');
    disp('5  PFR with Recycle');
    prompt='-1 To exit the program\n';
    num = input(prompt);
    

    if num==1
        %PFR
        f1 = @(Ca) (1+k2*Ca+k3*(Ca.^2))./(k1*Ca);
        Area = integral(f1,lower,upper);
        fprintf('Volume in Single PFR (Case 1): %f \n', v0*Area);
    end

    if num==2
        index =-1;

        if (method~=1)
            for i=1:length(C)
                if (lower==C(i))
                    index = i;
                end
            end
        end
        if(index~=-1)
            fprintf('Volume in Single MFR (Case 1): %f \n', v0*upper*Xa*R(index));
        end
        if(index==-1)
            Ca = lower;
            f1 = k1*Ca/(1+k2*Ca+k3*(Ca^2));
    %         Area = integral(f1,lower,upper);
            fprintf('Volume in Single MFR (Case 1): %f \n', v0*upper*Xa/f1);
        end
    end


    if num==3
         syms Ca
         f = (1+k2*Ca+k3*(Ca.^2))./(k1*Ca);
         df = diff(f);
         lower_y =  vpa(subs(f,Ca,lower));
         min_val =1e5;
         Ca_final = lower;
         for Ca1 =linspace(lower,upper)
             Ca1_y = vpa(subs(f,Ca,Ca1));
             slope = (Ca1_y - lower_y)/(upper-Ca1);
             diff_slope = vpa(subs(df,Ca,Ca1));
             net  = abs(diff_slope- slope);
             if(net<min_val)
                 min_val =net;
                 Ca_final = Ca1;
             end 
         end
         Ca_final_y =vpa(subs(f,Ca,Ca_final));
         A = [Ca_final,upper];
         B = [lower_y, Ca_final_y];
         hold on
         plot(A,B,'*')
         hold on
         line(A,B,'LineWidth',2);

       
         final_y = Ca_final_y;
         final_x = Ca_final;

         Area = (upper-final_x)*final_y + lower_y*(final_x-lower);
 
         fprintf('Volume (Case 1): %f \n', Area*v0);

         
         plot(Ca_final,Ca_final_y,'b*','MarkerSize',15);
         range_x = Ca_final-1:0.1:Ca_final+1;
         range_y = vpa(subs(df,Ca,Ca_final))*(range_x-Ca_final)+vpa(subs(f,Ca,Ca_final));
         hold on
         plot(range_x,range_y,'LineWidth',2);
         
    end

    if num==4
         point_1 = lower;
         point_2 = upper;
         syms Ca
         f = k1.*Ca./(1+k2.*Ca+k3.*(Ca.^2)); 
         f = 1./f;
         df = diff(f);
         
         slope = 0;

         tangent_point= 0;
         min_val = 1e5;
         df_fun = @(Ca) df;
         
      
         for x = point_1:0.05:point_2
            temp= vpa(subs(df,Ca,x));
            if (abs(temp-slope)<min_val)
               min_val = abs(temp-slope);
               final_x = x;
            end
         end
         
         final_y = vpa(subs(f,Ca,final_x));
         lower_y = vpa(subs(f,Ca,lower));

         fprintf('The tangent point comes out to be: (%0.4f,%0.4f) \n',final_x,final_y);

         Area1 = (upper-final_x)*final_y;
         f1 = @(Ca) (1+k2*Ca+k3*(Ca.^2))./(k1*Ca); 
         Area2 = integral(f1,lower,final_x);
         vol1 = v0*(Area1+Area2);
          

         Area3 = lower_y*(final_x-lower);
         f1 = @(Ca) (1+k2*Ca+k3*(Ca.^2))./(k1*Ca); 
         Area4 = integral(f1,final_x,upper);
         vol2 = v0*(Area3+Area4);
         
         if(vol2>vol1)
             fprintf("MFR will be followed by PFR\n");
             fprintf("MFR volume : %f, PFR volume : %f,Total volume : %f\n",Area1*v0,Area2*v0,vol1);
         end
         
         if(vol2<=vol1)
             fprintf("PFR will be followed by MFR\n");
             fprintf("MFR volume : %f, PFR volume : %f,Total volume : %f\n",Area3*v0,Area4*v0,vol2);

         end
         
         plot(final_x,final_y,'-m*','MarkerSize',20);
         range_x = point_1:0.1:point_2;
         range_y = vpa(subs(df,Ca,final_x))*(range_x-final_x)+vpa(subs(f,Ca,final_x));
         hold on
         plot(range_x,range_y,'LineWidth',2);
         
    end

    if num==5
        f1 = @(Ca) (1+k2*Ca+k3*(Ca.^2))./(k1*Ca);
        min_val =1e5;
        Ca_final = lower; % Just setting default:
        syms Ca
        f = (1+k2*Ca+k3*(Ca.^2))./(k1*Ca);
        for Ca1 = linspace(lower,upper)

            Area = integral(f1,lower,Ca1);
            LHS = Area/(Ca1-lower);
            RHS = vpa(subs(f,Ca,Ca1));
            net = abs(LHS-RHS);
            if(net <min_val)
                min_val = net;
                Ca_final = Ca1;
            end

        end
        plot(Ca_final,vpa(subs(f,Ca,Ca_final)),'-k*', 'MarkerSize',20);
        R = (upper - Ca_final)/(Ca_final- lower);
        fprintf("Ca and Recycle ratio comes out to be: %f and %f\n",Ca_final,R);
        Volume  = vpa(subs(f,Ca,Ca_final))*(upper-lower)*v0;
        fprintf("Volume comes out to be : %f\n",Volume);

      
    end

end
