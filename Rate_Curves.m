
user = "What is the lower limit of Ca?\n";
lower = input(user);
user  = "What is the upper limit of Ca?\n";
upper = input(user);
user = "What is the value of K1?\n";
k1 = input(user);
user = "What is the value of K2?\n";
k2 = input(user);
user = "What is the value of K3?\n";
k3 = input(user);

% Plotting rate curve 
Ca = linspace(lower,upper);
rate = k1.*Ca./(1+k2.*Ca+k3.*(Ca.^2)); 
figure();
plot(Ca,rate,'r','LineWidth',2);
hold on
title("Rate vs Concentration");
xlabel('Concentration'); ylabel('-rA');
num=2;

while(num~=-1)
    % Asking from user which action wants to execute
    disp('Select the corresponding number for respective operation you want to execute');
    disp('');
    disp('1  Derivative at a point');
    disp('2  Area under the curve');
    disp('3  Maximum value of function over given domain');
    disp('4  Minimum value of function over given domain');
    disp('5  Draw a straight line between 2 points ');
    prompt='-1 To exit the program\n';
    num = input(prompt);
    
    % Calculating derivative at point
    if(num==1)
        syms Ca
        prompt ='At what concentration value, you want to calculate derivative?\n';
        derivative_point = input(prompt); %INPUT

        f = k1.*Ca./(1+k2.*Ca+k3.*(Ca.^2)); 
        df = diff(f);
        result =vpa(subs(df,Ca,derivative_point));
        fprintf('The derivative at point comes out to be: %0.4f\n',result);
    
    
     % Calculating area under curve
    elseif(num==2)
        f1 = @(Ca) k1.*Ca./(1+k2.*Ca+k3.*(Ca.^2)); 
        Area = integral(f1,lower,upper);
        fprintf('Area comes out to be: %f \n',Area);
        % A = trapz(Ca,f)
    
     % Calculate maximum value of function
    elseif(num==3)
        maximum_value = max(rate);
        fprintf('Maximum value is: %f\n',maximum_value);
    
    
     % Calculate minimum value of function
    elseif(num==4)
        minimum_value = min(rate);
        fprintf('Minimum value is: %f\n',minimum_value);
    
    
    % Drawing straight line & finding tangent point
    elseif(num==5)
         prompt='What is the first point of straight line?\n';
         point_1 = input(prompt);
         prompt='What is the Second point of straight line?\n';
         point_2 = input(prompt);
         f1 = @(Ca) k1.*Ca./(1+k2.*Ca+k3.*(Ca.^2)); 
         y1 = f1(point_1);
         y2 = f1(point_2);
         A = [point_1,point_2];
         B = [y1,y2];
         hold on
         plot(A,B,'*')
         hold on
         line(A,B,'LineWidth',2);
    
         syms Ca
         f = k1.*Ca./(1+k2.*Ca+k3.*(Ca.^2)); 
         df = diff(f);
         
         slope = (y2-y1)/(point_2-point_1);
         fprintf('Slope of line comes out to be: %0.4f\n',slope);
         tangent_point= 0;
         min_val = 1e5;
         df_fun = @(Ca) df;
         
         % Checking point whose slope is to be same as above straight line
         for x = point_1:0.05:point_2
            temp= vpa(subs(df,Ca,x));
            if (abs(temp-slope)<min_val)
               min_val = abs(temp-slope);
               final_x = x;
            end
    
         end
         % Plotting the line
         final_y = vpa(subs(f,Ca,final_x));
         hold on
         plot(final_x,final_y,'b*');
         range_x = point_1:0.1:point_2;
         range_y = vpa(subs(df,Ca,final_x))*(range_x-final_x)+vpa(subs(f,Ca,final_x));
         hold on
         plot(range_x,range_y,'LineWidth',2);
         fprintf('The tangent point comes out to be: (%0.4f,%0.4f) \n',final_x,final_y);
    
    elseif(num==-1)
        disp('Exit the program successsfully');
    else
    
        disp('Wrong number has been given, please check the above format');
    end
end
