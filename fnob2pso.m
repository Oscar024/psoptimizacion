%SIMULACION DE DATOS ENTRENADOS
at1=sim(net1,PT);
at1=(at1*ns);
%TS=(TS*ns)

load sistst.dat
load realsistar.dat

sistst1=sistst;
x1=sistst1/ns;

rtarg=realsistar';
num=length(rtarg);
%SIMULANDO DATOS PRONOSTICADOS
sim1=sim(net1,x1);

%IMPRIMIR SOLO EL PRONOSITICO
pronostico1=rtarg;

 for j=1:num
     pronostico1(1,j)=sim1(1,j);
 end

 pronostico1=(pronostico1*ns);
 sim1=(sim1*ns);
 
 pronostico1=round(pronostico1);
%%%%%%%%%%%%%%%%%%%%
%INTEGRACION POR PROMEDIO

   prom=pronostico1;
   for iii=1:36
   erroresga(iii)=abs(rtarg(iii)-pronostico1(iii));  
end

errorestga=0;
for ii=1:36
   errorestga=errorestga+erroresga(ii);
end

errorestga=errorestga/36;
