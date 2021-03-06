clc;
clear;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MaxIt = 100;         % Numero maximo de iteraciones
Npar = 36;      % Numero de Patículas
Iter = 1;
errors= 0;


comienza=now;
horai=now;
comienza=horai;
horai=datestr(now,14);

load sisto1.dat
load tarsis.dat

% x = sisto1;
% ta = tarsis;

trnsis=sisto1;
%Buscar numero maximo en los vectores para normalizar
maxs=max(trnsis);
ns=max(maxs);
%Normalizando datos
PT=trnsis/ns;
ta=tarsis/ns;

SpaceSearch = [ 1 1 1 1;%  
                2 30 30 700 ];%    Espacio de busqueda de la nube


VelMax = 0.5.*(SpaceSearch(2,:)-SpaceSearch(1,:)); % Velocidad maxima de cierre
Constraint = [2,1.5];
Nvar = size(SpaceSearch,2); % Obtiene el numero de variables (dimensiones) 


%-- Velocidades iniciales de las particulas
Velocity  = zeros(Npar,Nvar);
      

%-- Inicialización de las posiciones de las partículas
swarm = repmat(SpaceSearch(1,:),Npar,1)+...
            repmat(SpaceSearch(2,:)-SpaceSearch(1,:),Npar,1).*...
            rand(Npar,Nvar);
   
%-- Inicialización de la aptitud (global y locales)
gbest = ones(MaxIt,1).*inf; % Mejor aptitud global
lbest = ones(Npar,1).*inf; % Mejores aptitudes locales
%--
%-- Inicialización las posiciones (globlal y locales)
pglobal = ones(1,Nvar)*inf; % Mejor posición global
plocal = ones(Npar,Nvar)*inf; % Mejores posiciónes locales
s1=pwd
s2='\error.txt'
dir = strcat(s1,s2)
%--crear arhivo para guardar errores
fid= fopen(dir, 'wt');
%Iter=1;
 
while (Iter <= MaxIt)
   [Npar t]= size(swarm);
   swarm = round(swarm);
   for i=1:Npar
 
      disp('Iniciando Entrenamiento...');
          
      %%%%%%%%%%%%%%%%%%%%%%%%%%%% PRIMER MODULO %%%%%%%%%%%%%%%%%%%%%%%%%%
       
    %if(swarm(i,1)==1)%Monolitica

        if(swarm(i,1)==1)% 1 modulo y  1 capa
            net1=newff(minmax(PT),[swarm(i,2),1],{'tansig','purelin','logsig'},'trainlm');
        end
    
        if(swarm(i,1)==2)% 1 modulo y  2 capa
            net1=newff(minmax(PT),[swarm(i,2),swarm(i,3),1],{'tansig','tansig','purelin','purelin','logsig'},'trainlm');
        end
    
%         if(swarm(i,2)==3)% 1 modulo y  3 capa
%             net1=newff(minmax(PT),[swarm(i,3),swarm(i,4),swarm(i,5),1],{'tansig','tansig','tansig','logsig'},'trainlm');
%         end
        net1.trainParam.show=NaN;
        net1.trainParam.goal=0.01;
        net1.trainParam.lr=0.01; 
        net1.trainParam.epochs = swarm(i,4);  
        [net1,tr1]=train(net1,PT,ta);
    %end
    
  
  
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCION OBJETIVO PARA CUANDO ES DE UN MODULO

%if(swarm(i,1)==1)
    fnob2pso();
    %errors=erroresga;
    %evalua4(i)=errors(i);    
    evalua4(i)=errorestga; 
%end


 clear resultadosGA
  

   fprintf(fid,['Error:' num2str(evalua4(i)) ' Iteracion:' int2str(Iter+1) ' Particulas:' int2str(i) ' Capas: ' int2str(swarm(i,1)) ' Neuronas capa 1: ' int2str(swarm(i,2))  ' Neuronas Capa 2: ' int2str(swarm(i,3)) ' Epocas: ' int2str(swarm(i,4)) '\n']); 

   
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMO CALCULAR ERRORES DEL GA


if(Iter==0)
    if(i==1)      
    vector(1)=100;
    end
    if(evalua4(i)<min(vector))
          % if (swarm(i,1)==1)
%                save('DowjonesPSO\Serie2\monolitica\evo18\mejorRed1', 'net1');
%                 save('DowjonesPSO\Serie2\monolitica\evo18\mejorPronostico1', 'pronostico1');
%               save('DowjonesPSO\Serie2\monolitica\evo18\DatosDivididosP1', 'pronosticoM1');
%               save('DowjonesPSO\Serie2\monolitica\evo18\errortortal', 'errorestpso');
       % end 
     
           
    end
    vector(i+1)=evalua4(i);
end



if(Iter~=0)
      vector(1)=100;
    if(evalua4(i)<min(vector))
      if (swarm(i,1)==1)
%              save('DowjonesPSO\Serie2\monolitica\evo18\', 'net1');
%               save('DowjonesPSO\Serie2\monolitica\evo18\mejorPronostico1', 'pronostico1');
%               save('DowjonesPSO\Serie2\monolitica\evo18\DatosDivididosP1', 'pronosticoM1');
%               save('DowjonesPSO\Serie2\monolitica\evo18\errortortal', 'errorestpso');
        end 
      
         vector(i+1)=evalua4(i);
end
end

 

%  fprintf(fid,['Error:' num2str(evalua4(i)) ' Iteracion:' int2str(Iter+1) ' Particula:' int2str(i) ' Modulos: ' int2str(swarm(i,1)) ' Numero de Capas: ' int2str(swarm(i,2))  ' Modulo 1: ' int2str(swarm(i,3:5))  '\n']); 
%     subplot(2,1,1);
%            plot(evalua4,'m*');xlabel('No. de Particulas');ylabel('Error');
%            text(0.5,0.9,['Error por Particulas= ',num2str(evalua4(i))],'Units','normalized');
%            set(gcf,'name','Funcion Objetivo','numbertitle','off');
%            drawnow;            
%            fprintf('Iteracion:%1.0f, Particulas %1.0f,',swarm,i);
%       

     end % del for de Particulas
    
        
fprintf(fid,['\n-----------------------------------\n\n']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
    %-- Actualización de la mejor posición local para cada partícula 
    
    if Iter > 1
       Besterrorestpso = errorestga< lbest;
       lbest = lbest.*not(Besterrorestpso) + erroresga.*Besterrorestpso;
       plocal(find(Besterrorestpso),:) = swarm(find(Besterrorestpso),:);
    else
       lbest = errorestga;
       plocal = swarm;
    end
    %--
    
    %-- Actualización la mejor posición global
    [best, pos] = min(lbest); 
    if best < gbest(Iter)
        gbest(Iter) = best;
        pglobal(Iter,:) = swarm(pos,:);
    else
        gbest(Iter) = gbest(Iter-1);
        pglobal(Iter,:) = pglobal(Iter-1,:);
    end
    %--
         Info(Iter,:) = [round(pglobal(Iter,1)),pglobal(Iter,2)];
    
    %-- Track best particle and display convergence
%     plot(gbest,'ro');xlabel('Iteracion'); ylabel('Best');
%     text(0.5,0.95,['Best = ', num2str(gbest(Iter))],'Units','normalized')
%     text(0.5,0.90,['Clusters = ', num2str(Info(Iter,1)),'  Fuzzifier: ',num2str(Info(Iter,2))],'Units','normalized');
%     drawnow;
%     %--
       clf;   %limpia la gráfica. 
            subplot(2,1,1);
           plot(evalua4,'m*');xlabel('No. de Particulas');ylabel('Error');
           text(0.5,0.9,['Error por Particula= ',num2str(evalua4(i))],'Units','normalized');
           set(gcf,'name','Funcion Objetivo','numbertitle','off');
           drawnow;
subplot(2,1,2);
plot(gbest,'mo');xlabel('Iteracion'); ylabel('log10(f(x))');
text(0.4,0.9,['Mejor Individuo por Iteracion= ', num2str(gbest(Iter))],'Units','normalized');   
drawnow;  
    %-- Actualiza la velocidad
    W = (0.9-0).*((MaxIt-Iter)/MaxIt) + 0; % peso de inercia con decremento lineal
    C = (0-0.9).*((MaxIt-Iter)/MaxIt) + 0.9; % coeficione de contricción con incremento lineal
    
    R1 = rand(Npar,Nvar); % Valoreas aleatorios para el componente cognitivo
    R2 = rand(Npar,Nvar); % Valoreas aleatorios para el componente social
    
    C1 = (0.5-2).*(Iter/MaxIt) + 2;% constante de acelaración del componente cognitivo
    C2 = (2-0.5).*(Iter/MaxIt) + 0.5;% constante de aceleración del componente social
    
     fprintf('Aceleracion Cognitiva: %f, Aceleracion Social: %f, Inercia: %f, Constriccion: %f,\n',...
            C1, C2, W, C)
    
    Cognitive = C1.*R1.*(plocal-swarm);% Componente Cognitivo
    Social = C2.*R2.*(repmat(pglobal(Iter,:),Npar,1)-swarm); % Componente Social
        
    Velocity = C*(W*Velocity + Cognitive + Social); % Calculo de las nuevas velocidades
    
    % Ajuste de velocidad a la velocidad Minima y Maxima de cierre
    Velocity = Velocity.*not(Velocity > repmat(VelMax,Npar,1)) + ...
               repmat(VelMax,Npar,1).*(Velocity > repmat(VelMax,Npar,1));
           
%     Velocity = Velocity.*not(Velocity < repmat(-VelMax,Npar,1)) + ...
%                repmat(-VelMax,Npar,1).*(Velocity < repmat(-VelMax,Npar,1));
    %--
    
    %-- Actualiza las posiciones de las particulas       
    swarm  = swarm + Velocity;
    
    % Mantiene las particulas dentro del espacio de busqueda
    swarm = swarm.*not(swarm < repmat(SpaceSearch(1,:),Npar,1)) + ...
                repmat(pglobal(Iter,:),Npar,1).*(swarm < repmat(SpaceSearch(1,:),Npar,1));
            
    swarm = swarm.*not(swarm > repmat(SpaceSearch(2,:),Npar,1)) + ...
                repmat(pglobal(Iter,:),Npar,1).*(swarm > repmat(SpaceSearch(2,:),Npar,1));
    %--
       Iter=Iter+1;   
%        inicial = gbest(1);
     end %termina while de las Iteraciones  

