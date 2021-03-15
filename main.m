function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 20-Jan-2020 08:43:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @main_OpeningFcn, ...
    'gui_OutputFcn',  @main_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global global_handle
global_handle = handles

set(gcf, 'WindowButtonMotionFcn',@mouseMove)
set(gcf, 'WindowButtonDownFcn', @buttonDown)
set(gcf, 'KeyPressFcn', @KeyboradCallBack)
set(handles.btn_load, 'Enable', 'Inactive');
set(handles.btn_next, 'Enable', 'Inactive');
set(handles.btn_prev, 'Enable', 'Inactive');

img.width = 256;
img.height = 256;
setappdata(gcf, 'datas', [])
setappdata(gcf, 'img', img)
setappdata(gcf,'mode', 'NULL');


function [success, hExes] = current_axes(object)
global global_handle;
C = get(object, 'CurrentPoint');
x = C(1,1);
y = C(1,2);
fn = fieldnames(global_handle);
hExes=0;
success=0;
for k=1:numel(fn)
    if strcmp(global_handle.(fn{k})(1).Type,'axes')==1
        axes = global_handle.(fn{k});
        pos = axes.Position;
        
        if pos(1) <= x && pos(1)+pos(3) > x && pos(2) < y && pos(2) + pos(4) >= y
            success=1;
            hExes = axes;
            return
        end
    end
end


function buttonDown(src, ~)
global global_handle

[success, a] = current_axes(src);
if success==1
    [x,y] = ginput(1);
    axes(a);
    delete(getappdata(gcf, 'plot'));
    p1 = plot(x,y, 'x', 'MarkerSize', 15, 'LineWidth', 1, 'MarkerEdgeColor','w', 'Color', [0.0, 0.0, 0.5]);
    setappdata(gcf,'plot',p1);
    
    y = floor(y);
    x = floor(x);
    img = getappdata(gcf, 'img');
    
    if y < 1 || y > img.height || x < 1 || x > img.width
        y, img.height, x, img.width
        return
    end
    
    mat_data = getappdata(gcf,'mat_data');
    set(global_handle.x_edit,'String',x);
    set(global_handle.y_edit,'String',y);
    set(global_handle.edit_disp, 'String', sprintf("%.2f / %.2f / %.2f", mat_data.pred(y,x),mat_data.GT(y,x),abs(mat_data.pred(y,x)-mat_data.GT(y,x))));
    
    axes(global_handle.cost_axes);
    disp = squeeze(0:mat_data.maxdisp-1);
    cost = squeeze(mat_data.costmap(y,x,:));
    plot(disp,cost);
    xline(mat_data.pred(y,x), 'Color', 'red');
    xline(mat_data.GT(y,x), 'Color', 'blue');
    
end

%         mouse2pixel(src)

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_prev.
function btn_prev_Callback(hObject, eventdata, handles)
% hObject    handle to btn_prev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




function y_edit_Callback(hObject, eventdata, handles)
% hObject    handle to y_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_edit as text
%        str2double(get(hObject,'String')) returns contents of y_edit as a double


% --- Executes during object creation, after setting all properties.
function y_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse press over axes background.
% hObject    handle to left_axes (see GCBO)
% eventdata  reserved - to be defined in a future versiouicontroln of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function mouseMove(object, eventdata)
%     global current_image_info
global global_handle

%     [x, y] = mouse2pixel(object);
%     if x ~= -1
%         set(global_handle.x_edit,'String',x)
%         set(global_handle.y_edit,'String',y)
%     end

function [normal_x, normal_y] = mouse2pixel(object)
global global_handle
img = getappdata(gcf,'img');

C = get(object, 'CurrentPoint');
x = C(1,1);
y = C(1,2);
fn = fieldnames(global_handle);
normal_x = -1;
normal_y = -1;
for k=1:numel(fn)
    if strcmp(global_handle.(fn{k}).Type,'axes')==1
        axes = global_handle.(fn{k});
        pos = axes.Position;
        
        if pos(1) <= x && pos(1)+pos(3) > x && pos(2) < y && pos(2) + pos(4) >= y
            normal_x = ((x - pos(1))/pos(3)) * img.width;
            normal_y = ((pos(4) - (y - pos(2)))/pos(4)) * img.height;
            normal_x = floor(normal_x);
            normal_y = floor(normal_y);
            return
        end
    end
end

%     sprintf("x: %f, y: %f", C(1,1), C(1,2))


% --- Executes during object creation, after setting all properties.
function left_axes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to left_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
%    set(gca,'ButtonDownFcn',left_axes_ButtonDownFcn())
% Hint: place code in OpeningFcn to populate left_axes



function x_edit_Callback(hObject, eventdata, handles)
% hObject    handle to x_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_edit as text
%        str2double(get(hObject,'String')) returns contents of x_edit as a double


% --- Executes during object creation, after setting all properties.
function x_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_next.
function btn_next_Callback(hObject, eventdata, handles)
% hObject    handle to btn_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in btn_load.
function btn_load_Callback(hObject, eventdata, handles)
% hObject    handle to btn_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function open_file()
datas = getappdata(gcf,'datas');
global global_handle

current_point = getappdata(gcf, 'current_point');

path = [datas{2, current_point} '/' datas{1, current_point}]; % 1 file name , 2 folder name
mat_data = load(path);
setappdata(gcf, 'mat_data', mat_data);

axes(global_handle.left_axes);
hold off;
imshow(mat_data.left);
impixelinfo();
hold on;

axes(global_handle.right_axes);
hold off;
imshow(mat_data.right);
impixelinfo();
hold on;

axes(global_handle.pred_axes);
hold off;
imagesc(mat_data.pred);
impixelinfo();
hold on;

axes(global_handle.gt_axes);
hold off;
imagesc(mat_data.GT);
impixelinfo();
hold on;

[h,w,~] = size(mat_data.left);
img.width = w;
img.height = h;
setappdata(gcf, 'datas', datas)
setappdata(gcf, 'img', img)

function confidence_show()
datas = getappdata(gcf,'datas');
global global_handle

current_point = getappdata(gcf, 'current_point');

path = [datas{2, current_point} '/' datas{1, current_point}]; % 1 file name , 2 folder name
mat_data = load(path);
setappdata(gcf, 'mat_data', mat_data);


axes(global_handle.pred_axes);
hold off;
imagesc(mat_data.CONF);
impixelinfo();
hold on;

function masked_image(mask)
datas = getappdata(gcf,'datas');
global global_handle

current_point = getappdata(gcf, 'current_point');

path = [datas{2, current_point} '/' datas{1, current_point}]; % 1 file name , 2 folder name
mat_data = load(path);
setappdata(gcf, 'mat_data', mat_data);


axes(global_handle.pred_axes);
hold off;
imagesc(mat_data.pred.*mask + -30.*(1-mask));
impixelinfo();
hold on;

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over btn_load.
function btn_load_ButtonDownFcn(hObject, eventdata, handles)
folder = uigetdir('./src','Select a Data File');
imgs = dir(fullfile(folder, '*.mat'));
datas = struct2cell(imgs);
setappdata(gcf, 'datas', datas)
setappdata(gcf, 'current_point', 1)
open_file();
% hObject    handle to btn_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_path_Callback(hObject, eventdata, handles)
% hObject    handle to edit_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_path as text
%        str2double(get(hObject,'String')) returns contents of edit_path as a double


% --- Executes during object creation, after setting all properties.
function edit_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_disp_Callback(hObject, eventdata, handles)
% hObject    handle to edit_disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_disp as text
%        str2double(get(hObject,'String')) returns contents of edit_disp as a double


% --- Executes during object creation, after setting all properties.
function edit_disp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on btn_next and none of its controls.
function btn_next_KeyPressFcn(hObject, eventdata, handles)


% hObject    handle to btn_next (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over btn_next.
function btn_next_ButtonDownFcn(hObject, eventdata, handles)
current_point = getappdata(gcf, 'current_point');
setappdata(gcf, 'current_point', 1 + current_point);
open_file();
% hObject    handle to btn_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
o

% --- Executes on button press in btn_error.
function btn_error_Callback(hObject, eventdata, handles)
key_processing('ERROR')


% hObject    handle to btn_error (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over btn_error.
function btn_error_ButtonDownFcn(hObject, eventdata, handles)

% hObject    handle to btn_error (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_error_Callback(hObject, eventdata, handles)
% hObject    handle to edit_error (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_error as text
%        str2double(get(hObject,'String')) returns contents of edit_error as a double


% --- Executes during object creation, after setting all properties.
function edit_error_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_error (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_conf.
function btn_conf_Callback(hObject, eventdata, handles)
% hObject    handle to btn_conf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over btn_conf.
function btn_conf_ButtonDownFcn(hObject, eventdata, handles)
key_processing('CONF')



% hObject    handle to btn_conf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btn_conf_error.
function btn_conf_error_Callback(hObject, eventdata, handles)
% hObject    handle to btn_conf_error (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over btn_conf_error.
function btn_conf_error_ButtonDownFcn(hObject, eventdata, handles)
    key_processing('CONF_ERROR')

function key_processing(obj_mode)
mode = getappdata(gcf,'mode');
mat_data = getappdata(gcf,'mat_data');

if strcmp(obj_mode,'CONF_ERROR')
    if ~strcmp(mode,'CONF_ERROR')
        masked_image(mat_data.CONF & abs(mat_data.GT-mat_data.pred)>3)
        setappdata(gcf,'mode','CONF_ERROR')
    else
        masked_image(ones(size(mat_data.pred)))
        setappdata(gcf,'mode','NULL')
    end
elseif strcmp(obj_mode,'CONF')
    mode = getappdata(gcf,'mode');
    mat_data = getappdata(gcf,'mat_data');
    
    if ~strcmp(mode,'CONF')
        masked_image(mat_data.CONF)
        setappdata(gcf,'mode','CONF')
    else
        masked_image(ones(size(mat_data.pred)))
        setappdata(gcf,'mode','NULL')
    end
elseif strcmp(obj_mode,'ERROR')
    mode = getappdata(gcf,'mode');
    mat_data = getappdata(gcf,'mat_data');
    
    if ~strcmp(mode,'ERROR')
        masked_image(abs(mat_data.GT-mat_data.pred)>3)
        setappdata(gcf,'mode','ERROR')
    else
        masked_image(ones(size(mat_data.pred)))
        setappdata(gcf,'mode','NULL')
    end
elseif strcmp(obj_mode,'CONF_SHOW')
    mode = getappdata(gcf,'mode');
    mat_data = getappdata(gcf,'mat_data');
    
    if ~strcmp(mode,'CONF_SHOW')
        confidence_show()
        setappdata(gcf,'mode','CONF_SHOW')
    else
        masked_image(ones(size(mat_data.pred)))
        setappdata(gcf,'mode','NULL')
    end
end
% hObject    handle to btn_conf_error (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function KeyboradCallBack(hObject, eventdata, handles)
% determine the key that was pressed
keyPressed = eventdata.Key;
switch keyPressed
    case '1'
        key_processing('ERROR')
    case '2'
        key_processing('CONF')
    case '3'
        key_processing('CONF_ERROR')
    case '4'
        key_processing('CONF_SHOW')
    case 'return'
        global global_handle
        mat_data = getappdata(gcf,'mat_data');
        x = str2num(get(global_handle.x_edit, 'string'));
        y = str2num(get(global_handle.y_edit, 'string'));
        set(global_handle.edit_disp, 'String', sprintf("%.2f / %.2f / %.2f", mat_data.pred(y,x),mat_data.GT(y,x),abs(mat_data.pred(y,x)-mat_data.GT(y,x))));

        axes(global_handle.cost_axes);
        disp = squeeze(0:mat_data.maxdisp-1);
        cost = squeeze(mat_data.costmap(y,x,:));
        plot(disp,cost);
        xline(mat_data.pred(y,x), 'Color', 'red');
        xline(mat_data.GT(y,x), 'Color', 'blue');
end