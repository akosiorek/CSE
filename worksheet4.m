% Scientific Computing Lab - Computational Science and Engineering
% Worksheet 4 Submission (07.12.2014)

% Group 8:
% Joshi, Saumitra Vinay
% Kosiorek, Adam
% Perez de Alba Ortiz, Alberto

% In this worksheet the instationary heat equation with known boundary
% conditions is solved using:
% 1. An spatial discretization based on the symmetric finite difference 
% approximation of the second order derivatives
% 2. Two temporal discretizations respectively based on the Explicit and 
% the Implicit Euler method.
% Solutions are tested for different time-step and mesh sizes. Stability is
% evaluated for each case.

function [] = worksheet4()

    close all
    clear
    clc
    Lx = 1; Ly = Lx;
    Nx = [3, 7, 15, 31]; Ny = Nx;   % Arrays of Nx, Ny values
    N = {'3', '7', '15', '31'}; % N: string version
    deltas = 2.^(-6: -1: -12);  % Array of timesteps
    dels = {'1/64', '1/128', '1/256', '1/512', '1/1024', '1/2048', '1/4096'};   % deltas: string version
    
    dispTimes = [1/8, 2/8, 3/8, 4/8];   % Create array of display times
    dT = {'1/8', '2/8', '3/8', '4/8'};   % Display times: string version
    
    figH = 1: length(dispTimes);    % Create figure handles
    for i = 1: length(figH)
        figure(figH(i));    % Create figures
        set(figH(i), 'Visible', 'off'); % Hide them temporarily
        set(figH(i), 'Position', [25, 25, 1400, 900]);  % Set size
        set(gcf, 'color', 'white');
    end
    
    %Create matrix to mark stable cases
    %stabilityExp = ones(length(Nx),length(deltas));
    %stabilityImp = ones(length(Nx),1);
    
    fprintf('Solving Explicit Euler scheme ... \n\n');
    for i = 1: length(Nx)
        fprintf(strcat('Solving for Nx=Ny=', N{i}, ' ... \n\n' ));
        for j = 1: length(deltas)
            T = [zeros(1,Nx(i)+2); zeros(Nx(i),1),ones(Nx(i),Nx(i)), zeros(Nx(i),1); zeros(1,Nx(i)+2)]; %Initialize T matrix 
            for k=1:length(dispTimes)
                T = ExpEulTemporalSolver(deltas(j), dispTimes(k)-1/8, dispTimes(k), T, Lx, Ly);  % Call Explicit Euler Temporal Solver and update T
                x = 0: 1/(Nx(i)+1): 1;   % Set x and y
                y = 0: 1/(Ny(i)+1): 1;
                
                figure(figH(k)); %Set new figure
                rows=length(Nx); %Set subplot rows and columns
                columns=length(deltas);
                handles=zeros(rows,columns);
                handles(i,j) = subplot(rows,columns,j+(i-1)*columns);
                set(gcf, 'renderer', 'zbuffer');
                set(gca, 'fontsize', 8);
                mesh(x, y, T); %Surface plot
                pbaspect([1 1 1]);
                xlabel('x'); ylabel('y'); zlabel('T');
                
                %Subplot column labels
                if i == 1
                    text(0.25, 1.1, strcat('dt=', dels{j}), 'Units', 'normalized', 'FontSize', 12);
                end
                
                %Subplot row labels
                if j == 1
                    text(-1.1, 0.5, strcat('Nx=Ny=', N{i}), 'Units', 'normalized', 'FontSize', 12);
                end
                
                if i == 1 && j == 4
                    text(0 , 5.0 , strcat('State of Solutions of Explicit Euler scheme at t = ', dT(k)), 'FontSize', 14) ;
                end
                
                set(figH(k), 'Visible', 'off'); % Hide figure temporarily
                
                %Indicate if case is stable 
                %*considering that unstability causes oscillations that make T < 0
                if (any(T(:) < 0))
                    stabilityExp{i,j} = '0\t\t';
                else 
                    stabilityExp{i,j} = '1\t\t';
                end
              
            end
        end
    end
    
    fprintf('Solving Implicit Euler scheme ... \n\n');
    for i = 1: length(Nx)
        fprintf(strcat('Solving for Nx=Ny=', N{i}, ' ... \n\n' ));
        j = 1;
        T = [zeros(1,Nx(i)+2); zeros(Nx(i),1),ones(Nx(i),Nx(i)), zeros(Nx(i),1); zeros(1,Nx(i)+2)]; %Initialize T matrix 
        for k = 1:length(dispTimes)
            T = ImpEulTemporalSolver(deltas(j), dispTimes(k)-1/8, dispTimes(k), T, Lx, Ly);  % Call Explicit Euler Temporal Solver and update T
            x = 0: 1/(Nx(i)+1): 1;   % Set x and y
            y = 0: 1/(Ny(i)+1): 1;
            
            figure(4+k); %Set new figure
            set(4+k, 'Visible', 'off'); % Hide figure temporarily
            set(4+k, 'Position', [50, 50, 500, 900]);  % Set size
            set(gcf, 'color', 'white');
            rows = length(Nx); %Set subplot rows and columns
            columns = 1;
            handles = zeros(rows,columns);
            handles(i,j) = subplot(rows,columns,j+(i-1)*columns);
            set(gcf, 'renderer', 'zbuffer');
            set(gca, 'fontsize', 8);
            mesh(x, y, T); %Surface plot
            pbaspect([1 1 1]);
            xlabel('x'); ylabel('y'); zlabel('T');           
            
            %Subplot column labels
            if i == 1
                text(0.25, 1.1, strcat('dt=', dels{j}), 'Units', 'normalized', 'FontSize', 12);
                text(0 , 5.0 , strcat('State of Solutions of Implicit Euler scheme at t = ', dT(k)), 'FontSize', 14) ;           
            end
            %Subplot row labels
            if j == 1
                text(-1.75, 0.5, strcat('Nx=Ny=', N{i}), 'Units', 'normalized', 'FontSize', 12);
            end
            
            set(4+k, 'Visible', 'off'); % Hide figure temporarily
            
            %Indicate if case is stable 
            %*considering that unstability causes oscillations that make T < 0
             if (any(T(:) < 0))
                    stabilityImp{i,j} = '0\t';
                else 
                    stabilityImp{i,j} = '1\t';
                end
        end            
    end
    
    %Display stability matrix
    dtlabels = {'dt=1/64 \t', 'dt=1/128\t', 'dt=1/256\t', 'dt=1/512\t', 'dt=1/1024\t', 'dt=1/2048\t', 'dt=1/4096\t'};
    Nlabels = {'Nx=Ny=3\t' 'Nx=Ny=7\t' 'Nx=Ny=15' 'Nx=Ny=31'};
       
    fprintf('\t\t Stable Cases for Explicit Euler Scheme \n\n')
    fprintf(strcat('\t\t',dtlabels{1:end},'\n\n'));
    for i=1:length(Nlabels)
        fprintf(strcat(Nlabels{i},'\t',stabilityExp{i,1:end},'\n\n'));
    end
    
    fprintf('\t\t Stable Cases for Implicit Euler Scheme \n\n')
    fprintf(strcat('\t\t',dtlabels{1},'\n\n'));
    for i=1:length(Nlabels)
        fprintf(strcat(Nlabels{i},'\t',stabilityImp{i,1},'\n\n'));
    end
    
    %Display and save plots
    fprintf('Displaying and saving plots ... \n\n');
   
    dTlexp = ['Exp1by8.jpg', 'Exp2by8.jpg', 'Exp3by8.jpg', 'Exp4by8.jpg'];   % Display times: filename version
    dTlimp = ['Imp1by8.jpg', 'Imp2by8.jpg', 'Imp3by8.jpg', 'Imp4by8.jpg'];   % Display times: filename vers    
    
    k = 1;
    for i = 1: length(figH)
        figure(figH(i));    % Activate figure i
        set(gcf,'PaperUnits','inches','PaperPosition',[0 0 13 8])
        saveas(figH(i), dTlexp(k: k+10));
        k = k + 11;
    end
    k = 1;
    for i=1:4
        figure(4+i);
        set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8 10])
        saveas(4+i, dTlimp(k: k+10));
        k = k + 11;
    end
    
    fprintf('Program terminated succesfully\n\n');
    
end
