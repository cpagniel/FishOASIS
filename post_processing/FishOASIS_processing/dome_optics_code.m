%% Position and Size of Image Produced by Dome
% https://www.scubageek.com/articles/wwwdome.html

n = 1.33; % index of refraction in water
np = 1.492; % index of refraction in dome
npp = 1.00; % index of refraction air

r1 = 8; % inches, outer dome radii
r2 = 7.75; % inches, inner dome radii
d = r1-r2; % inches, dome thickness
p = 39.3701; % inches (1 m), object distance relative to external vertex
g = 3.5; % inches, distance from dome principal plane to lens primary principal plane

%% From Jenkins and White, "Fundamentals of Optics" (McGraw-Hill 1957), Chapter 5

f1 = n*(r1/(np-n));      % primary focal length of dome's external surface
f1p = f1*np/n;            % secondary focal length of dome's external surface

f2p = np*(r2/(npp-np));     % primary focal length of dome's internal surface
f2pp = f2p*npp/np;          % secondary focal length of dome's internal surface

novrf = np/f1p + npp/f2pp - (d/f1p)*(npp/f2pp);

f = n/novrf;             % primary focal length of the dome
fpp = f*npp/n;             % secondary focal length of the dome

A1F = -f*(1-d/f2p);       % position of the dome's primary focal plane relative to the dome's external vertex (on the dome axis)
A1H = f*d/f2p;             % position of the dome's primary principal plane relative to the dome's external vertex (on the dome axis)

A2Fpp = fpp*(1.-d/f1p);    % position of the dome's secondary focal plane relative to the dome's internal vertex (on the dome axis)
A2Hpp = -fpp*d/f1p;        % position of the dome's secondary principal plane relative to the dome's internal vertex (on the dome axis)

s = p+A1H;                 % s=object distance relative to primary principal plane
                           
spp = npp/(n/f - n/s);    % image distance relative to secondary principal plane
ppp = spp+A2Hpp+d;         % image distance relative to external vertex

m = -(n/npp)*(spp/s);      % size of image relative to size of object
view = -(spp-g)/(s+g)/m;   % view=tangent of lens' effective half-angle of view divided by tangent of lens' in-air half-angle of view
