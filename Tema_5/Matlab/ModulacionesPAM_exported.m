classdef ModulacionesPAM_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        GridLayout                      matlab.ui.container.GridLayout
        LeftPanel                       matlab.ui.container.Panel
        InstantemuestreoEditField       matlab.ui.control.NumericEditField
        InstantemuestreoEditFieldLabel  matlab.ui.control.Label
        GrficasButtonGroup              matlab.ui.container.ButtonGroup
        ConstelacinRxButton             matlab.ui.control.RadioButton
        ConstelacinTxButton             matlab.ui.control.RadioButton
        PulsoTxRxButton                 matlab.ui.control.RadioButton
        DetectorButton                  matlab.ui.control.RadioButton
        SxwButton                       matlab.ui.control.RadioButton
        DiagramadeojoButton             matlab.ui.control.RadioButton
        RetardomuestrasEditField        matlab.ui.control.NumericEditField
        RetardomuestrasLabel            matlab.ui.control.Label
        hCEditField                     matlab.ui.control.EditField
        hCEditFieldLabel                matlab.ui.control.Label
        sigmaEditField                  matlab.ui.control.NumericEditField
        sigmaEditFieldLabel             matlab.ui.control.Label
        CodificacionListBox             matlab.ui.control.ListBox
        CodificacionListBoxLabel        matlab.ui.control.Label
        alphaEditField                  matlab.ui.control.NumericEditField
        alphaLabel                      matlab.ui.control.Label
        TipodepulsoListBox              matlab.ui.control.ListBox
        TipodepulsoListBoxLabel         matlab.ui.control.Label
        RightPanel                      matlab.ui.container.Panel
        ErrorescometidosEditField       matlab.ui.control.NumericEditField
        ErrorescometidosEditFieldLabel  matlab.ui.control.Label
        UIAxes                          matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end


    properties (Access = private)
        L = 10;
        Ts = 100;
        N = 1000;
        hTR = zeros(1,1000); % Description
        a = zeros(1,1000);
        y = zeros(1,1000);
        yn = zeros(1,1000);
        Sx = zeros(1,1000);
        w = zeros(1,1000);
        ydelay = zeros(1,1000);
        yISI = zeros(1,1000);
        yALL = zeros(1,1000);
        hC = 0;
        t0 = 0;
    end


    methods (Access = private)

        function h = PulsoTX(app)
            switch lower(app.TipodepulsoListBox.Value)
                case 'nrz'
                    h = [zeros(1,(app.L-2)*app.Ts/2) 0:1/app.Ts:1-1/app.Ts 1 1-1/app.Ts:-1/app.Ts:0 zeros(1,(app.L-2)*app.Ts/2)];
                case 'rz'
                    h = [zeros(1,(app.L-1)*app.Ts/2) 0:2/app.Ts:1-2/app.Ts 1 1-2/app.Ts:-2/app.Ts:0 zeros(1,(app.L-1)*app.Ts/2)];
                case 'coseno alzado'
                    h = rcosdesign(app.alphaEditField.Value,app.L,app.Ts,'normal');
                    h = h./max(h);
                case 'nyquist'
                    h = rcosdesign(0,app.L,app.Ts,'normal');
                    h = h./max(h);
                case 'manchester'
                    h = [zeros(1,(app.L-2)*app.Ts/2) 0:-1/app.Ts:-0.5 -0.5+3/app.Ts:3/app.Ts:1-3/app.Ts 1 1-3/app.Ts:-3/app.Ts:-0.5 -0.5+1/app.Ts:1/app.Ts:0 zeros(1,(app.L-2)*app.Ts/2)];
            end
        end

        function a = Simbolos(app)
            switch lower(app.CodificacionListBox.Value)
                case 'polar'
                    a = 2*randi([0,1],1,app.N)-1;
                    a = upsample(a,app.Ts);         %Relleno con ceros para poder filtrar
                    a = [a zeros(1,app.L*app.Ts)];   %Añado ceros al final para permitir que el filtro se descargue
                case 'unipolar'
                    a = randi([0,1],1,app.N);
                    a = upsample(a,app.Ts);         %Relleno con ceros para poder filtrar
                    a = [a zeros(1,app.L*app.Ts)];   %Añado ceros al final para permitir que el filtro se descargue
                case 'bipolar'
                    a = randi([0,1],1,app.N);
                    unos = find(a==1);
                    signos = 2*rem(1:length(unos),2) - 1;
                    a(unos) = a(unos).*signos;
                    a = upsample(a,app.Ts);         %Relleno con ceros para poder filtrar
                    a = [a zeros(1,app.L*app.Ts)];   %Añado ceros al final para permitir que el filtro se descargue
            end
        end

        function ActualizaDatos(app)
            try 
                eval(['hC = ' app.hCEditField.Value ';']);
            catch ME
                app.hCEditField.Value = '[1 0.2]';
                hC = [1 0.2];
            end
            app.hC = hC;
            sigma = app.sigmaEditField.Value;
            delay = app.RetardomuestrasEditField.Value;
            if length(hC)>1
                hC = upsample(hC,app.Ts);
            end
            hC = [zeros(1,delay) hC];
            h = filter(hC,1,app.hTR);
            app.y = filter(h,1,app.a);
            app.y = app.y + sigma*randn(size(app.y));
            [app.Sx, app.w] = pwelch(app.y);  %Calculo la densidad espectral de potencia
            app.Sx = smooth(app.Sx,app.Ts);
            app.Sx = app.Sx./max(app.Sx);
        end

        function ActualizaGrafica(app)
            if app.DiagramadeojoButton.Value
                ojo = buffer(app.y,2*app.Ts,app.Ts);
                plot(app.UIAxes, ojo(:,app.L:end-app.L),'b'); %Quito las primeras y últimas tramas porque no son válidas
                app.UIAxes.XLim = [1 2*app.Ts+1];
                app.UIAxes.YLim = [min(app.y)-0.2 max(app.y)+0.2];
                app.UIAxes.XTick = [1 app.Ts+1 2*app.Ts+1];
                app.UIAxes.XTickLabel = {'0','T_s','2\cdot T_s'};
                grid(app.UIAxes,'on')
            elseif app.SxwButton.Value
                plot(app.UIAxes,app.w, 10*log10(app.Sx));
                app.UIAxes.XLim = [0 12*pi/100];
                app.UIAxes.YLim = [-70 0];
                app.UIAxes.XTickMode = 'auto';
                app.UIAxes.XTickLabelMode = 'auto';
                grid(app.UIAxes,'on')
            elseif app.DetectorButton.Value
                x = app.y(1+(length(app.hC)*app.Ts)+(app.L*app.Ts)/2:end+1-app.Ts-(app.L*app.Ts)/2);
                arx = x(1+app.t0:app.Ts:end);
                plot(app.UIAxes,x)
                hold(app.UIAxes,'on');
                plot(app.UIAxes, 1+app.t0:app.Ts:length(x),arx,'ro');
                app.UIAxes.XLim = [1 length(x)];
                app.UIAxes.YLim = [min(x)-0.2 max(x)+0.2];
                app.UIAxes.XTickMode = 'auto';
                app.UIAxes.XTickLabelMode = 'auto';
                grid(app.UIAxes,'on')
                hold(app.UIAxes,'off');
                atx = app.a(1+length(app.hC)*app.Ts:app.Ts:length(app.a));
                atx = atx(1:end-app.L-ceil(app.t0/app.Ts));
                switch lower(app.CodificacionListBox.Value)
                    case 'polar'
                        errores = length(find(atx-sign(arx)));
                    case 'unipolar'
                        errores = length(find(atx-round(arx)));
                    case 'bipolar'
                        errores = length(find(atx-round(arx)));
                end
                app.ErrorescometidosEditField.Value = errores;
            elseif app.PulsoTxRxButton.Value
                plot(app.UIAxes, app.hTR)
                app.UIAxes.XLim = [1 app.L*app.Ts];
                app.UIAxes.YLim = [min(app.hTR)-0.2 max(app.hTR)+0.2];
                app.UIAxes.XTickMode = 'auto';
                app.UIAxes.XTickLabelMode = 'auto';
            elseif app.ConstelacinTxButton.Value
                atx = app.a(1:app.Ts:length(app.a));
                atx = atx(1:end-app.L);
                plot(app.UIAxes, atx, zeros(size(atx)),'ro','LineWidth', 3);
                app.UIAxes.XLim = [min(atx)-0.2 max(atx)+0.2];
                app.UIAxes.YLim = [-1 1];
                app.UIAxes.XTickMode = 'auto';
                app.UIAxes.XTickLabelMode = 'auto';
            elseif app.ConstelacinRxButton.Value
                x = app.y(1+(length(app.hC)*app.Ts)+(app.L*app.Ts)/2:end+1-app.Ts-(app.L*app.Ts)/2);
                arx = x(1+app.t0:app.Ts:end);
                atx = app.a(1+length(app.hC)*app.Ts:app.Ts:length(app.a));
                atx = atx(1:end-app.L-ceil(app.t0/app.Ts));
                switch lower(app.CodificacionListBox.Value)
                    case 'polar'
                        errores = length(find(atx-sign(arx)));
                        unos = find(atx==1);
                        ceros = find(atx==-1);
                    case 'unipolar'
                        errores = length(find(atx-round(arx)));
                        unos = find(atx==1);
                        ceros = find(atx==0);
                    case 'bipolar'
                        errores = length(find(atx-round(arx)));
                        unos = find(sign(atx).*atx==1);
                        ceros = find(atx==0);
                end

                plot(app.UIAxes, arx(unos), zeros(size(arx(unos))),'ro','LineWidth', 3);
                hold(app.UIAxes,'on')
                plot(app.UIAxes, arx(ceros), zeros(size(arx(ceros))),'go','LineWidth', 3);
                app.UIAxes.XLim = [min(arx)-0.2 max(arx)+0.2];
                app.UIAxes.YLim = [-1 1];
                app.UIAxes.XTickMode = 'auto';
                app.UIAxes.XTickLabelMode = 'auto';
                hold(app.UIAxes,'off')

                app.ErrorescometidosEditField.Value = errores;
            end
        end
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.hTR = app.PulsoTX;
            app.a = app.Simbolos;
            app.ActualizaDatos;
            app.ActualizaGrafica;
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {588, 588};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {220, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end

        % Value changed function: TipodepulsoListBox
        function TipodepulsoListBoxValueChanged(app, event)
            value = app.TipodepulsoListBox.Value;
            if contains(value,'Coseno Alzado')
                app.alphaEditField.Enable=1;
                app.alphaLabel.Enable=1;
                app.CodificacionListBox.Enable = 1;
            elseif contains(value,'Manchester')
                app.alphaEditField.Enable=0;
                app.alphaLabel.Enable = 0;
                app.CodificacionListBox.Enable = 0;
                app.CodificacionListBox.Value = 'Polar';
                app.a = app.Simbolos;
            else
                app.alphaEditField.Enable=0;
                app.alphaLabel.Enable = 0;
                app.CodificacionListBox.Enable = 1;
            end
            app.hTR = app.PulsoTX;
            app.ActualizaDatos;
            app.ActualizaGrafica;
        end

        % Value changed function: alphaEditField
        function alphaEditFieldValueChanged(app, event)
            value = app.alphaEditField.Value;
            if ~isnumeric(value)
                value = 0;
            end
            app.hTR = app.PulsoTX;
            app.ActualizaDatos;
            app.ActualizaGrafica;
        end

        % Value changed function: CodificacionListBox
        function CodificacionListBoxValueChanged(app, event)
            value = app.CodificacionListBox.Value;
            app.a = app.Simbolos;
            app.ActualizaDatos;
            app.ActualizaGrafica;
        end

        % Selection changed function: GrficasButtonGroup
        function GrficasButtonGroupSelectionChanged(app, event)
            selectedButton = app.GrficasButtonGroup.SelectedObject;
            selectedButton.Text
            if contains(selectedButton.Text,'Detector')
                app.ErrorescometidosEditField.Visible = 1;
                app.ErrorescometidosEditFieldLabel.Visible = 1;
                app.InstantemuestreoEditField.Enable = 1;
                app.InstantemuestreoEditFieldLabel.Enable = 1;
            elseif contains(selectedButton.Text, 'Constelación Rx')
                app.InstantemuestreoEditField.Enable = 1;
                app.InstantemuestreoEditFieldLabel.Enable = 1;
                app.ErrorescometidosEditField.Visible = 1;
                app.ErrorescometidosEditFieldLabel.Visible = 1;
            elseif contains(selectedButton.Text, 'Constelación Tx')
                app.InstantemuestreoEditField.Enable = 1;
                app.InstantemuestreoEditFieldLabel.Enable = 1;
                app.ErrorescometidosEditField.Visible = 0;
                app.ErrorescometidosEditFieldLabel.Visible = 0;
            else
                app.ErrorescometidosEditField.Visible = 0;
                app.ErrorescometidosEditFieldLabel.Visible = 0;
                app.InstantemuestreoEditField.Enable = 0;
                app.InstantemuestreoEditFieldLabel.Enable = 0;
            end
            app.ActualizaGrafica;
        end

        % Value changed function: sigmaEditField
        function sigmaEditFieldValueChanged(app, event)
            value = app.sigmaEditField.Value;
            if ~isnumeric(value)
                value = 0.05;
            end
            app.ActualizaDatos;
            app.ActualizaGrafica;
        end

        % Value changed function: hCEditField
        function hCEditFieldValueChanged(app, event)
            value = app.hCEditField.Value;
            app.ActualizaDatos;
            app.ActualizaGrafica;
        end

        % Value changed function: RetardomuestrasEditField
        function RetardomuestrasEditFieldValueChanged(app, event)
            value = app.RetardomuestrasEditField.Value;
            app.ActualizaDatos;
            app.ActualizaGrafica;
        end

        % Value changed function: InstantemuestreoEditField
        function InstantemuestreoEditFieldValueChanged(app, event)
            value = app.InstantemuestreoEditField.Value;
            app.t0 = value;
            app.ActualizaDatos;
            app.ActualizaGrafica;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 973 588];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {220, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create TipodepulsoListBoxLabel
            app.TipodepulsoListBoxLabel = uilabel(app.LeftPanel);
            app.TipodepulsoListBoxLabel.HorizontalAlignment = 'right';
            app.TipodepulsoListBoxLabel.Position = [12 339 79 22];
            app.TipodepulsoListBoxLabel.Text = 'Tipo de pulso';

            % Create TipodepulsoListBox
            app.TipodepulsoListBox = uilistbox(app.LeftPanel);
            app.TipodepulsoListBox.Items = {'NRZ', 'RZ', 'Coseno Alzado', 'Nyquist', 'Manchester'};
            app.TipodepulsoListBox.ValueChangedFcn = createCallbackFcn(app, @TipodepulsoListBoxValueChanged, true);
            app.TipodepulsoListBox.Position = [107 267 100 96];
            app.TipodepulsoListBox.Value = 'NRZ';

            % Create alphaLabel
            app.alphaLabel = uilabel(app.LeftPanel);
            app.alphaLabel.HorizontalAlignment = 'right';
            app.alphaLabel.Enable = 'off';
            app.alphaLabel.Position = [53 543 35 22];
            app.alphaLabel.Text = 'alpha';

            % Create alphaEditField
            app.alphaEditField = uieditfield(app.LeftPanel, 'numeric');
            app.alphaEditField.ValueChangedFcn = createCallbackFcn(app, @alphaEditFieldValueChanged, true);
            app.alphaEditField.Enable = 'off';
            app.alphaEditField.Position = [110 543 100 22];
            app.alphaEditField.Value = 0.8;

            % Create CodificacionListBoxLabel
            app.CodificacionListBoxLabel = uilabel(app.LeftPanel);
            app.CodificacionListBoxLabel.HorizontalAlignment = 'right';
            app.CodificacionListBoxLabel.Position = [13 227 73 22];
            app.CodificacionListBoxLabel.Text = 'Codificacion';

            % Create CodificacionListBox
            app.CodificacionListBox = uilistbox(app.LeftPanel);
            app.CodificacionListBox.Items = {'Polar', 'Unipolar', 'Bipolar'};
            app.CodificacionListBox.ValueChangedFcn = createCallbackFcn(app, @CodificacionListBoxValueChanged, true);
            app.CodificacionListBox.Position = [107 191 100 60];
            app.CodificacionListBox.Value = 'Polar';

            % Create sigmaEditFieldLabel
            app.sigmaEditFieldLabel = uilabel(app.LeftPanel);
            app.sigmaEditFieldLabel.HorizontalAlignment = 'right';
            app.sigmaEditFieldLabel.Position = [50 507 38 22];
            app.sigmaEditFieldLabel.Text = 'sigma';

            % Create sigmaEditField
            app.sigmaEditField = uieditfield(app.LeftPanel, 'numeric');
            app.sigmaEditField.ValueChangedFcn = createCallbackFcn(app, @sigmaEditFieldValueChanged, true);
            app.sigmaEditField.Position = [110 507 100 22];
            app.sigmaEditField.Value = 0.05;

            % Create hCEditFieldLabel
            app.hCEditFieldLabel = uilabel(app.LeftPanel);
            app.hCEditFieldLabel.HorizontalAlignment = 'right';
            app.hCEditFieldLabel.Position = [51 469 25 22];
            app.hCEditFieldLabel.Text = 'hC';

            % Create hCEditField
            app.hCEditField = uieditfield(app.LeftPanel, 'text');
            app.hCEditField.ValueChangedFcn = createCallbackFcn(app, @hCEditFieldValueChanged, true);
            app.hCEditField.HorizontalAlignment = 'right';
            app.hCEditField.Position = [109 469 101 22];
            app.hCEditField.Value = '[1 0.2]';

            % Create RetardomuestrasLabel
            app.RetardomuestrasLabel = uilabel(app.LeftPanel);
            app.RetardomuestrasLabel.HorizontalAlignment = 'right';
            app.RetardomuestrasLabel.Position = [33 431 61 28];
            app.RetardomuestrasLabel.Text = {'Retardo'; '[muestras]'};

            % Create RetardomuestrasEditField
            app.RetardomuestrasEditField = uieditfield(app.LeftPanel, 'numeric');
            app.RetardomuestrasEditField.ValueChangedFcn = createCallbackFcn(app, @RetardomuestrasEditFieldValueChanged, true);
            app.RetardomuestrasEditField.Position = [110 434 100 22];
            app.RetardomuestrasEditField.Value = 30;

            % Create GrficasButtonGroup
            app.GrficasButtonGroup = uibuttongroup(app.LeftPanel);
            app.GrficasButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @GrficasButtonGroupSelectionChanged, true);
            app.GrficasButtonGroup.Title = 'Gráficas';
            app.GrficasButtonGroup.Position = [13 19 193 163];

            % Create DiagramadeojoButton
            app.DiagramadeojoButton = uiradiobutton(app.GrficasButtonGroup);
            app.DiagramadeojoButton.Text = 'Diagrama de ojo';
            app.DiagramadeojoButton.Position = [14 96 110 22];
            app.DiagramadeojoButton.Value = true;

            % Create SxwButton
            app.SxwButton = uiradiobutton(app.GrficasButtonGroup);
            app.SxwButton.Text = 'Sx(w)';
            app.SxwButton.Position = [14 75 51 22];

            % Create DetectorButton
            app.DetectorButton = uiradiobutton(app.GrficasButtonGroup);
            app.DetectorButton.Text = 'Detector';
            app.DetectorButton.Position = [14 54 68 22];

            % Create PulsoTxRxButton
            app.PulsoTxRxButton = uiradiobutton(app.GrficasButtonGroup);
            app.PulsoTxRxButton.Text = 'Pulso (Tx-Rx)';
            app.PulsoTxRxButton.Position = [14 117 94 22];

            % Create ConstelacinTxButton
            app.ConstelacinTxButton = uiradiobutton(app.GrficasButtonGroup);
            app.ConstelacinTxButton.Text = 'Constelación Tx';
            app.ConstelacinTxButton.Position = [14 31 109 22];

            % Create ConstelacinRxButton
            app.ConstelacinRxButton = uiradiobutton(app.GrficasButtonGroup);
            app.ConstelacinRxButton.Text = 'Constelación Rx';
            app.ConstelacinRxButton.Position = [14 8 110 22];

            % Create InstantemuestreoEditFieldLabel
            app.InstantemuestreoEditFieldLabel = uilabel(app.LeftPanel);
            app.InstantemuestreoEditFieldLabel.HorizontalAlignment = 'right';
            app.InstantemuestreoEditFieldLabel.Enable = 'off';
            app.InstantemuestreoEditFieldLabel.Position = [39 388 56 28];
            app.InstantemuestreoEditFieldLabel.Text = {'Instante '; 'muestreo'};

            % Create InstantemuestreoEditField
            app.InstantemuestreoEditField = uieditfield(app.LeftPanel, 'numeric');
            app.InstantemuestreoEditField.ValueChangedFcn = createCallbackFcn(app, @InstantemuestreoEditFieldValueChanged, true);
            app.InstantemuestreoEditField.Enable = 'off';
            app.InstantemuestreoEditField.Position = [110 391 100 22];

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create UIAxes
            app.UIAxes = uiaxes(app.RightPanel);
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [6 49 741 533];

            % Create ErrorescometidosEditFieldLabel
            app.ErrorescometidosEditFieldLabel = uilabel(app.RightPanel);
            app.ErrorescometidosEditFieldLabel.HorizontalAlignment = 'right';
            app.ErrorescometidosEditFieldLabel.Visible = 'off';
            app.ErrorescometidosEditFieldLabel.Position = [269 28 104 22];
            app.ErrorescometidosEditFieldLabel.Text = 'Errores cometidos';

            % Create ErrorescometidosEditField
            app.ErrorescometidosEditField = uieditfield(app.RightPanel, 'numeric');
            app.ErrorescometidosEditField.Editable = 'off';
            app.ErrorescometidosEditField.Visible = 'off';
            app.ErrorescometidosEditField.Position = [388 28 100 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ModulacionesPAM_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end