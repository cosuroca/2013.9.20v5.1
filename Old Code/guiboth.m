function varargout = guiboth(varargin)
% guiboth MATLAB code for guiboth.fig
%      guiboth, by itself, creates a new GUIBOTH or raises the existing
%      singleton*.
%
%      H = guiboth returns the handle to a new GUIBOTH or the handle to
%      the existing singleton*.
%
%      guiboth('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in guiboth.M with the given input arguments.
%
%      guiboth('Property','Value',...) creates a new guiboth or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiboth_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiboth_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiboth

% Last Modified by GUIDE v2.5 21-Aug-2013 10:33:19

%#ok<*DEFNU,*INUSD,*INUSL>

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiboth_OpeningFcn, ...
                   'gui_OutputFcn',  @guiboth_OutputFcn, ...
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


% --- Executes just before guiboth is made visible.
function guiboth_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiboth (see VARARGIN)
                
inputs.costs.raw.s2ttray = 7;
inputs.costs.raw.t2itray = 8;
inputs.costs.raw.spots = 2000;
inputs.costs.raw.strings = 1;
inputs.costs.raw.s2t = 1;
inputs.costs.raw.t2i = 1;

inputs.costs.labor.s2ttray = 5;
inputs.costs.labor.t2itray = 5;
inputs.costs.labor.spots = 25;
inputs.costs.labor.strings = 2;
inputs.costs.labor.s2t = 3;
inputs.costs.labor.t2i = 3;

tablelabels = {'Cost of Conductor + Tray','Max Volt Drop %','Total Cost of System',...
               'Cost of Conductor Labor','Cost of Tray Labor','Length of Conductor',...
               'Tables per Quad','Quadrant Height','Quadrant Width','Wire Size'};

load('sizes.mat')

global cheapestData
global finalData
[cheapestData,finalData] = optGraphAlencon(inputs);

handles.s1 = scatter(handles.axes,finalData(:,3),finalData(:,2),'x');
grid on
xlim([1000000 2000000]);
set(get(handles.axes,'XLabel'),'String','Total Cost of System');
set(get(handles.axes,'YLabel'),'String','Max Voltage Drop Percent');
set(get(handles.axes,'Title'),'String','Max VDP vs. Total Cost');

tableData = cheapestData;
wireNames = sizes(tableData(:,10))';
tableData(:,10) = [];
tableData = num2cell(tableData);
tableData = horzcat(tableData,wireNames);

tableData = vertcat(tablelabels,tableData);

set(handles.uitable3,'Data',tableData);

handles.timer = timer('ExecutionMode','fixedRate',...
                    'Period', .5,...
                    'TimerFcn', {@GUIUpdate,handles});
                

% Choose default command line output for guiboth
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes guiboth wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guiboth_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function sliderRawSpot_Callback(hObject, eventdata, handles)
% hObject    handle to sliderRawSpot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.textRawSpot,'String',num2str(get(handles.sliderRawSpot,'Value')));

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderRawSpot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderRawSpot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function textRawSpot_Callback(hObject, eventdata, handles)
% hObject    handle to textRawSpot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.sliderRawSpot,'Value',str2double(get(handles.textRawSpot,'String')));

% Hints: get(hObject,'String') returns contents of textRawSpot as text
%        str2double(get(hObject,'String')) returns contents of textRawSpot as a double


% --- Executes during object creation, after setting all properties.
function textRawSpot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textRawSpot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textRawTrunk2Inv_Callback(hObject, eventdata, handles)
% hObject    handle to textRawTrunk2Inv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.sliderRawTrunk2Inv,'Value',str2double(get(handles.textRawTrunk2Inv,'String')));

% Hints: get(hObject,'String') returns contents of textRawTrunk2Inv as text
%        str2double(get(hObject,'String')) returns contents of textRawTrunk2Inv as a double


% --- Executes during object creation, after setting all properties.
function textRawTrunk2Inv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textRawTrunk2Inv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sliderRawTrunk2Inv_Callback(hObject, eventdata, handles)
% hObject    handle to sliderRawTrunk2Inv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.textRawTrunk2Inv,'String',num2str(get(handles.sliderRawTrunk2Inv,'Value')));

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderRawTrunk2Inv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderRawTrunk2Inv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function textLaborT2I_Callback(hObject, eventdata, handles)
% hObject    handle to textLaborT2I (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.sliderLaborT2I,'Value',str2double(get(handles.textLaborT2I,'String')));

% Hints: get(hObject,'String') returns contents of textLaborT2I as text
%        str2double(get(hObject,'String')) returns contents of textLaborT2I as a double


% --- Executes during object creation, after setting all properties.
function textLaborT2I_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textLaborT2I (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sliderLaborT2I_Callback(hObject, eventdata, handles)
% hObject    handle to sliderLaborT2I (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.textLaborT2I,'String',num2str(get(handles.sliderLaborT2I,'Value')));

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderLaborT2I_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderLaborT2I (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in buttonCalculate.
function buttonCalculate_Callback(hObject, eventdata, handles)
% hObject    handle to buttonCalculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

inputs.costs.raw.s2ttray = str2double(get(handles.textRawS2TTray,'String'));
inputs.costs.raw.t2itray = str2double(get(handles.textRawT2ITray,'String'));
inputs.costs.raw.spots = str2double(get(handles.textRawSpot,'String'));
inputs.costs.raw.strings = str2double(get(handles.textRawStrings,'String'));
inputs.costs.raw.s2t = str2double(get(handles.textRawSpot2Trunk,'String'));
inputs.costs.raw.t2i = str2double(get(handles.textRawTrunk2Inv,'String'));

inputs.costs.labor.s2ttray = str2double(get(handles.textLaborS2TTray,'String'));
inputs.costs.labor.t2itray = str2double(get(handles.textLaborT2ITray,'String'));
inputs.costs.labor.spots = str2double(get(handles.textLaborSpots,'String'));
inputs.costs.labor.strings = str2double(get(handles.textLaborStrings,'String'));
inputs.costs.labor.s2t = str2double(get(handles.textLaborS2TTray,'String'));
inputs.costs.labor.t2i = str2double(get(handles.textLaborT2ITray,'String'));

tablelabels = {'Cost of Conductor + Tray';'Max Volt Drop %';'Total Cost of System';...
               'Cost of Conductor Labor';'Cost of Tray Labor';'Length of Conductor';...
               'Tables per Quad';'Quadrant Height';'Quadrant Width';'Wire Size'};

load('sizes.mat')

global cheapestData
global finalData
[cheapestData,finalData] = optGraphAlencon(inputs);
handles = guidata(guiboth);
handles.s1 = s1;
handles.s2 = s2;
handles.s3 = s3;
handles.s4 = s4;
guidata(guiboth,handles);

wireNames = sizes(cheapestData(8,:));
cheapestData(8,:) = [];
cheapestData = num2cell(cheapestData);
cheapestData = vertcat(cheapestData,wireNames);

cheapestData = horzcat(tablelabels,cheapestData);

set(handles.uitable3,'Data',cheapestData);


function textLaborS2T_Callback(hObject, eventdata, handles)
% hObject    handle to textLaborS2T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.sliderLaborS2T,'Value',str2double(get(handles.textLaborS2T,'String')));

% Hints: get(hObject,'String') returns contents of textLaborS2T as text
%        str2double(get(hObject,'String')) returns contents of textLaborS2T as a double


% --- Executes during object creation, after setting all properties.
function textLaborS2T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textLaborS2T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sliderLaborS2T_Callback(hObject, eventdata, handles)
% hObject    handle to sliderLaborS2T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.textLaborS2T,'String',num2str(get(handles.sliderLaborS2T,'Value')));

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderLaborS2T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderLaborS2T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function textLaborS2TTray_Callback(hObject, eventdata, handles)
% hObject    handle to textLaborS2TTray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.sliderLaborS2TTray,'Value',str2double(get(handles.textLaborS2TTray,'String')));

% Hints: get(hObject,'String') returns contents of textLaborS2TTray as text
%        str2double(get(hObject,'String')) returns contents of textLaborS2TTray as a double


% --- Executes during object creation, after setting all properties.
function textLaborS2TTray_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textLaborS2TTray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sliderLaborS2TTray_Callback(hObject, eventdata, handles)
% hObject    handle to sliderLaborS2TTray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.textLaborS2TTray,'String',num2str(get(handles.sliderLaborS2TTray,'Value')));

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderLaborS2TTray_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderLaborS2TTray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function textLaborSpots_Callback(hObject, eventdata, handles)
% hObject    handle to textLaborSpots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.sliderLaborSpots,'Value',str2double(get(handles.textLaborSpots,'String')));

% Hints: get(hObject,'String') returns contents of textLaborSpots as text
%        str2double(get(hObject,'String')) returns contents of textLaborSpots as a double


% --- Executes during object creation, after setting all properties.
function textLaborSpots_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textLaborSpots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sliderLaborSpots_Callback(hObject, eventdata, handles)
% hObject    handle to sliderLaborSpots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.textLaborSpots,'String',num2str(get(handles.sliderLaborSpots,'Value')));

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderLaborSpots_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderLaborSpots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function textLaborStrings_Callback(hObject, eventdata, handles)
% hObject    handle to textLaborStrings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.sliderLaborStrings,'Value',str2double(get(handles.textLaborStrings,'String')));

% Hints: get(hObject,'String') returns contents of textLaborStrings as text
%        str2double(get(hObject,'String')) returns contents of textLaborStrings as a double


% --- Executes during object creation, after setting all properties.
function textLaborStrings_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textLaborStrings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sliderLaborStrings_Callback(hObject, eventdata, handles)
% hObject    handle to sliderLaborStrings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.textLaborStrings,'String',num2str(get(handles.sliderLaborStrings,'Value')));

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderLaborStrings_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderLaborStrings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function textLaborT2ITray_Callback(hObject, eventdata, handles)
% hObject    handle to textLaborT2ITray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.sliderLaborT2ITray,'Value',str2double(get(handles.textLaborT2ITray,'String')));

% Hints: get(hObject,'String') returns contents of textLaborT2ITray as text
%        str2double(get(hObject,'String')) returns contents of textLaborT2ITray as a double


% --- Executes during object creation, after setting all properties.
function textLaborT2ITray_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textLaborT2ITray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sliderLaborT2ITray_Callback(hObject, eventdata, handles)
% hObject    handle to sliderLaborT2ITray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.textLaborT2ITray,'String',num2str(get(handles.sliderLaborT2ITray,'Value')));

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderLaborT2ITray_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderLaborT2ITray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function textRawT2ITray_Callback(hObject, eventdata, handles)
% hObject    handle to textRawT2ITray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.sliderRawT2ITray,'Value',str2double(get(handles.textRawT2ITray,'String')));

% Hints: get(hObject,'String') returns contents of textRawT2ITray as text
%        str2double(get(hObject,'String')) returns contents of textRawT2ITray as a double


% --- Executes during object creation, after setting all properties.
function textRawT2ITray_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textRawT2ITray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sliderRawT2ITray_Callback(hObject, eventdata, handles)
% hObject    handle to sliderRawT2ITray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.textRawT2ITray,'String',num2str(get(handles.sliderRawT2ITray,'Value')));

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderRawT2ITray_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderRawT2ITray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function textRawSpot2Trunk_Callback(hObject, eventdata, handles)
% hObject    handle to textRawSpot2Trunk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.sliderRawSpot2Trunk,'Value',str2double(get(handles.textRawSpot2Trunk,'String')));

% Hints: get(hObject,'String') returns contents of textRawSpot2Trunk as text
%        str2double(get(hObject,'String')) returns contents of textRawSpot2Trunk as a double


% --- Executes during object creation, after setting all properties.
function textRawSpot2Trunk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textRawSpot2Trunk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sliderRawSpot2Trunk_Callback(hObject, eventdata, handles)
% hObject    handle to sliderRawSpot2Trunk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.textRawSpot2Trunk,'String',num2str(get(handles.sliderRawSpot2Trunk,'Value')));

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderRawSpot2Trunk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderRawSpot2Trunk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function textRawStrings_Callback(hObject, eventdata, handles)
% hObject    handle to textRawStrings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.sliderRawStrings,'Value',str2double(get(handles.textRawStrings,'String')));

% Hints: get(hObject,'String') returns contents of textRawStrings as text
%        str2double(get(hObject,'String')) returns contents of textRawStrings as a double


% --- Executes during object creation, after setting all properties.
function textRawStrings_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textRawStrings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sliderRawStrings_Callback(hObject, eventdata, handles)
% hObject    handle to sliderRawStrings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.textRawStrings,'String',num2str(get(handles.sliderRawStrings,'Value')));

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderRawStrings_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderRawStrings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function textRawS2TTray_Callback(hObject, eventdata, handles)
% hObject    handle to textRawS2TTray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.sliderRawS2TTray,'Value',str2double(get(handles.textRawS2TTray,'String')));

% Hints: get(hObject,'String') returns contents of textRawS2TTray as text
%        str2double(get(hObject,'String')) returns contents of textRawS2TTray as a double


% --- Executes during object creation, after setting all properties.
function textRawS2TTray_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textRawS2TTray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sliderRawS2TTray_Callback(hObject, eventdata, handles)
% hObject    handle to sliderRawS2TTray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.textRawS2TTray,'String',num2str(get(handles.sliderRawS2TTray,'Value')));

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderRawS2TTray_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderRawS2TTray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function uitable3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderRawS2TTray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in buttonUpdate.
function buttonUpdate_Callback(hObject, eventdata, handles)
% hObject    handle to buttonUpdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

inputs.costs.raw.s2ttray = str2double(get(handles.textRawS2TTray,'String'));
inputs.costs.raw.t2itray = str2double(get(handles.textRawT2ITray,'String'));
inputs.costs.raw.spots = str2double(get(handles.textRawSpot,'String'));
inputs.costs.raw.strings = str2double(get(handles.textRawStrings,'String'));
inputs.costs.raw.s2t = str2double(get(handles.textRawSpot2Trunk,'String'));
inputs.costs.raw.t2i = str2double(get(handles.textRawTrunk2Inv,'String'));

inputs.costs.labor.s2ttray = str2double(get(handles.textLaborS2TTray,'String'));
inputs.costs.labor.t2itray = str2double(get(handles.textLaborT2ITray,'String'));
inputs.costs.labor.spots = str2double(get(handles.textLaborSpots,'String'));
inputs.costs.labor.strings = str2double(get(handles.textLaborStrings,'String'));
inputs.costs.labor.s2t = str2double(get(handles.textLaborS2TTray,'String'));
inputs.costs.labor.t2i = str2double(get(handles.textLaborT2ITray,'String'));

tablelabels = {'Cost of Conductor + Tray';'Max Volt Drop %';'Total Cost of System';...
               'Cost of Conductor Labor';'Cost of Tray Labor';'Length of Conductor';...
               'Tables per Quad';'Quadrant Height';'Quadrant Width';'Wire Size'};

load('sizes.mat')

global cheapestData
global finalData
[cheapestData,finalData] = optGraphAlencon(inputs);

wireNames = sizes(cheapestData(8,:));
cheapestData(8,:) = [];
cheapestData = num2cell(cheapestData);
cheapestData = vertcat(cheapestData,wireNames);

cheapestData = horzcat(tablelabels,cheapestData);

set(handles.uitable3,'Data',cheapestData);

% set(handles.s1,'ydata',finalData(:,2));
% set(handles.s2,'ydata',finalData(:,2));
% set(handles.s3,'ydata',finalData(:,2));
% set(handles.s4,'ydata',finalData(:,2));
% 
% set(handles.s1,'xdata',finalData(:,1));
% set(handles.s2,'xdata',finalData(:,1) + finalData(:,4) + finalData(:,5));
% set(handles.s3,'xdata',finalData(:,1) + inputs.costs.raw.spots*4*finalData(:,6));
% set(handles.s4,'xdata',finalData(:,3));

% --- Executes on button press in startButton.
function startButton_Callback(hObject, eventdata, handles)
% hObject    handle to startButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
start(handles.timer)


function GUIUpdate(obj,event,handles)

inputs.costs.raw.s2ttray = str2double(get(handles.textRawS2TTray,'String'));
inputs.costs.raw.t2itray = str2double(get(handles.textRawT2ITray,'String'));
inputs.costs.raw.spots = str2double(get(handles.textRawSpot,'String'));
inputs.costs.raw.strings = str2double(get(handles.textRawStrings,'String'));
inputs.costs.raw.s2t = str2double(get(handles.textRawSpot2Trunk,'String'));
inputs.costs.raw.t2i = str2double(get(handles.textRawTrunk2Inv,'String'));

inputs.costs.labor.s2ttray = str2double(get(handles.textLaborS2TTray,'String'));
inputs.costs.labor.t2itray = str2double(get(handles.textLaborT2ITray,'String'));
inputs.costs.labor.spots = str2double(get(handles.textLaborSpots,'String'));
inputs.costs.labor.strings = str2double(get(handles.textLaborStrings,'String'));
inputs.costs.labor.s2t = str2double(get(handles.textLaborS2TTray,'String'));
inputs.costs.labor.t2i = str2double(get(handles.textLaborT2ITray,'String'));

tablelabels = {'Cost of Conductor + Tray','Max Volt Drop %','Total Cost of System',...
               'Cost of Conductor Labor','Cost of Tray Labor','Length of Conductor',...
               'Tables per Quad','Quadrant Height','Quadrant Width','Wire Size'};

load('sizes.mat')

global finalData
global cheapestData
[cheapestData,finalData] = optGraphAlencon(inputs);
pause(.5)
set(handles.s1,'ydata',finalData(:,2));
set(handles.s1,'xdata',finalData(:,3));

tableData = cheapestData;
wireNames = sizes(tableData(:,10))';
tableData(:,10) = [];
tableData = num2cell(tableData);
tableData = horzcat(tableData,wireNames);

tableData = vertcat(tablelabels,tableData);

set(handles.uitable3,'Data',[]);
set(handles.uitable3,'Data',tableData);

% --- Executes on button press in stopButton.
function stopButton_Callback(hObject, eventdata, handles)
% hObject    handle to stopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stop(handles.timer)

% --- Executes on button press in stopButton.
function toggleButton_Callback(hObject, eventdata, handles)
% hObject    handle to stopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.toggleButton,'String'),'Alencon')
    set(handles.toggleButton,'String','Conventional')
    set(handles.boxText,'String','CBs')
    set(handles.boxLaborText,'String','CBs')
    set(handles.uipanel3,'String','String to CB');
    set(handles.uipanel5,'String','String to CB');
    set(handles.uipanel4,'String','CB to Inverter');
    set(handles.uipanel6,'String','CB to Inverter');
else
    set(handles.toggleButton,'String','Alencon')
    set(handles.boxText,'String','SPOTs')
    set(handles.boxLaborText,'String','SPOTs')
    set(handles.uipanel3,'String','SPOT to Trunk');
    set(handles.uipanel5,'String','SPOT to Trunk');
    set(handles.uipanel4,'String','Trunk to Inverter');
    set(handles.uipanel6,'String','Trunk to Inverter');
end
