function [ M ] = LunarAnimation(position, ObjectRadius, OrbitColour, ObjectTexture, ObjectDetails)

% Function to model moon orbiting the earth, while the earth is orbiting
% the sun.
%
% [M] is the output variable containing the frames of the animation.
%
% [position] is a 3D matrix that contains the x, y, z positions of the
% three objects (sun, earth and moon) for each day.
%
% [ObjectRadius] is a 3x1 matrix containing the values for the radii of the
% bodies.
%
% [OrbitColour] is an 3x3 matrix containing the colours of the bodies'
% orbits, to be used when plotting the objects, as an RGB matrix.
%
% [ObjectTexture] is 3x13 character matrix that contains the names of the
% textures that will be used to map onto the three objects - the sun, earth
% and moon.
%
% [ObjectDetails] Contains Details of the axial tilt, object spin and
% object light for each body.
% [AxialTilt; ObjectSpin; ObjectLight]
%

% Authors: Ailis Muldoon, Sara Lolatte, Joan McCarthy 
% $Revision: 8 $ $Date: 2015/04/27 09:39:17 $
%% Set initial values

vertices = 80;
[t_range rubbish numbodies] = size(position);
theta = 0; 
zoomfactor = 0.1;
zoomfactor1 = 15;
t_index = 0:t_range;
t_units = char('Days');
count = 3;

%% Set view and axis
    
handle = figure(2);
axis([-1 1 -1 1 -1 1])
axis off
view(3)
hold all
fullscreen = get(0,'ScreenSize');
% Set Background to Black
set(handle,'color',[1 1 1],'Position',[0 -50 fullscreen(3) fullscreen(4)],'Toolbar','figure');
camzoom(zoomfactor);
    

 % play button
    uicontrol('Style', 'pushbutton','String','Play','Position', [1200 560 100 50],'callback', 'uiresume(gcbf)');
    % pause button
    uicontrol('Style', 'pushbutton','String', 'Pause','Position', [1200 500 100 50],'Callback', 'uiwait(gcf)');  
    
    
%% Set Radii of Bodies

% Radii of bodies
[x y z] = sphere(vertices);
vertices = vertices+1;
xrad = zeros(vertices,vertices,numbodies);
yrad = zeros(vertices,vertices,numbodies);
zrad = zeros(vertices,vertices,numbodies);
	
% Set bodies to correct radius sizes
for n = 1:numbodies,
	xrad(:,:,n) = x.*ObjectRadius(n);
	yrad(:,:,n) = y.*ObjectRadius(n);
	zrad(:,:,n) = z.*ObjectRadius(n);
end
        
%% Plot
   
TextHandle = annotation('textarrow',[0.87,0.1],[0.6,0.1],'String',['Time = '],'TextColor',[1 1 1],'FontSize',12,'HeadStyle','none','lineStyle','none');
    
% Cycle through all values(t_range)
for k = 1:t_range
    if count == 0
        TextHandle1 = annotation('textarrow',[0.92,0.1],[0.6,0.1],'String',[(num2str(t_index(k)/3)),...
        ' ',t_units],'TextColor',[1 1 1],'FontSize',12,'HeadStyle','none','lineStyle','none');
        count=2;
    else    
    count=count-1;
    end
    
%     if k >= ceil(t_range/4)
%         % find angle of displacement of earth from postive x-axis
%         
%         % postive x
%         if x > 0
%             theta = atan(abs(position(k,2,2))/abs(position(k,1,2)));
%         % add pi for negative x
%         elseif x < 0
%             theta = pi + atan(abs(position(k,2,2))/abs(position(k,1,2)));
%         end
%         
%         % move radial distance away from earth, then convert to Cartesian
%         % co-ordinates and take as new camera position
%         [xpos, ypos] = pol2cart(theta, abs(position(k,1:2,2))+0.1);
%         campos([xpos(1), ypos(1), position(k,3,2)+0.05]);
%         % point camera at earth
%         camtarget([position(k,1,2) position(k,2,2) position(k,3,2)]);
%                 
%     end     
%            
%     if k == ceil(t_range/4)
%         camzoom(zoomfactor1);
%     end
    
% Cycle through each body       
    for n = 1:numbodies
        % Plot path 
%         if k < t_range/4
            plot3(position(1:k,1,n),position(1:k,2,n),position(1:k,3,n),'Color',OrbitColour(n,:),'linewidth',5.5);
%         end
            
        object(n) = surf(xrad(:,:,n)+position(k,1,n),yrad(:,:,n)+position(k,2,n),...
		zrad(:,:,n)+position(k,3,n),'LineStyle', 'none');  
                             
        % Set body texture or colour
       % [X,map] = imread(ObjectTexture(n,:));
        set(object(n),'FaceColor',OrbitColour(n,:));
            
        % tilt bodies at specified Axial tilt
        % body position at an axis described by [0 0]
        rotate(object(n),[0 0], ObjectDetails(1,n),...
        [position(k,1,n) position(k,2,n) position(k,3,n)]);
                
        % rotate body about the direction vector given by its current
        % body position at an axis described by [0 90]
        rotate(object(n),[0 90], 30*k*(ObjectDetails(2,n)),...
        [position(k,1,n) position(k,2,n) position(k,3,n)]);
                
        % set the sun as the luminous body
        if ObjectDetails(3,n) == 1
            set(object(n),'AmbientStrength',1);
            LightHandle(n) = light('Style','local','Position',...
            [position(k,1,n) position(k,2,n) position(k,3,n)]);
        end    
    end
       
    M(k) = getframe(gcf);
      
    % remove bodies created and light source from disk
    for n = 1:numbodies;
        delete(object(n));
        if ObjectDetails(3,n) == 1
            delete(LightHandle);
        end
    end
    
    % Remove Text Handle
    if k>1 && count == 3
        delete(TextHandle1);
    end
end

delete(TextHandle);

end