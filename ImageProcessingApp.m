classdef ImageProcessingApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        BrowseButton           matlab.ui.control.Button
        SaveImageButton        matlab.ui.control.Button
        ImageInfoButton        matlab.ui.control.Button
        ConvertToBWButton      matlab.ui.control.Button
        CropImageButton        matlab.ui.control.Button
        ResizeImageButton      matlab.ui.control.Button
        FlipImageButton        matlab.ui.control.Button
        CombineImagesButton    matlab.ui.control.Button
        UIAxes                 matlab.ui.control.UIAxes
        SaveFormatDropDown     matlab.ui.control.DropDown
        FlipDirectionDropDown  matlab.ui.control.DropDown
        CombineMethodDropDown  matlab.ui.control.DropDown
    end

    properties (Access = private)
        Image % Main image
        SecondImage % For combining images
    end

    methods (Access = private)

        function updateImage(app)
            if ~isempty(app.Image)
                imshow(app.Image, 'Parent', app.UIAxes);
            end
        end

        function displayImageInfo(app)
            if isempty(app.Image)
                msgbox('No image loaded. Please load an image first.', 'Error', 'error');
                return;
            end

            [height, width, channels] = size(app.Image);
            infoStr = sprintf('Image Information:\nHeight: %d pixels\nWidth: %d pixels\nChannels: %d', height, width, channels);

            % Calculate file size
            tempFile = [tempname '.jpg'];
            imwrite(app.Image, tempFile, 'jpg', 'Quality', 90);
            fileInfo = dir(tempFile);
            compressedSize = fileInfo.bytes;
            delete(tempFile);

            infoStr = sprintf('%s\nCompressed File Size: %.2f KB', infoStr, compressedSize/1024);

            msgbox(infoStr, 'Image Information');
        end

    end

    % Callbacks that handle component events
    methods (Access = private)

        function BrowseButtonPushed(app, event)
            [file, path] = uigetfile({'*.jpg;*.png;*.bmp;*.tiff', 'Image Files'});
            if file ~= 0
                fullPath = fullfile(path, file);
                app.Image = imread(fullPath);
                app.updateImage();
            end
        end

        function SaveImageButtonPushed(app, event)
            if isempty(app.Image)
                msgbox('No image to save. Please load an image first.', 'Error', 'error');
                return;
            end
            [file, path] = uiputfile({'*.jpg;*.png;*.bmp;*.tiff', 'Image Files'});
            if file ~= 0
                imwrite(app.Image, fullfile(path, file), app.SaveFormatDropDown.Value);
                msgbox('Image saved successfully.', 'Success');
            end
        end

        function ImageInfoButtonPushed(app, event)
            app.displayImageInfo();
        end

        function ConvertToBWButtonPushed(app, event)
            if isempty(app.Image)
                msgbox('No image loaded. Please load an image first.', 'Error', 'error');
                return;
            end
            if size(app.Image, 3) == 3
                grayImage = rgb2gray(app.Image);
            else
                grayImage = app.Image;
            end
            app.Image = imbinarize(grayImage);
            app.updateImage();
        end

        function CropImageButtonPushed(app, event)
            if isempty(app.Image)
                msgbox('No image loaded. Please load an image first.', 'Error', 'error');
                return;
            end
        
            prompt = {'Enter x-coordinate:', 'Enter y-coordinate:', 'Enter width:', 'Enter height:'};
            dlgtitle = 'Crop Image';
            dims = [1 35];
            definput = {'0', '0', '100', '100'}; % Default values for x, y, width, and height
            answer = inputdlg(prompt, dlgtitle, dims, definput);
        
            if isempty(answer)
                return;
            end
        
            x = str2double(answer{1});
            y = str2double(answer{2});
            width = str2double(answer{3});
            height = str2double(answer{4});
        
            if isnan(x) || isnan(y) || isnan(width) || isnan(height) || width <= 0 || height <= 0
                msgbox('Invalid dimensions entered. Please try again.', 'Error', 'error');
                return;
            end
        
            % Perform the cropping
            try
                rect = [x, y, width, height];
                app.Image = imcrop(app.Image, rect);
                app.updateImage();
            catch ME
                msgbox('Error during cropping. Please check the dimensions.', 'Error', 'error');
            end
        end

        function ResizeImageButtonPushed(app, event)
            if isempty(app.Image)
                msgbox('No image loaded. Please load an image first.', 'Error', 'error');
                return;
            end
            [height, width, ~] = size(app.Image);
            prompt = {'Enter new width:', 'Enter new height:'};
            dlgtitle = 'Resize Image';
            dims = [1 35];
            definput = {num2str(width), num2str(height)};
            answer = inputdlg(prompt, dlgtitle, dims, definput);
            if ~isempty(answer)
                newWidth = str2double(answer{1});
                newHeight = str2double(answer{2});
                app.Image = imresize(app.Image, [newHeight, newWidth]);
                app.updateImage();
            end
        end

        function FlipImageButtonPushed(app, event)
            if isempty(app.Image)
                msgbox('No image loaded. Please load an image first.', 'Error', 'error');
                return;
            end
            direction = app.FlipDirectionDropDown.Value;
            if strcmp(direction, 'Horizontal')
                app.Image = fliplr(app.Image);
            elseif strcmp(direction, 'Vertical')
                app.Image = flipud(app.Image);
            end
            app.updateImage();
        end

        function CombineImagesButtonPushed(app, event)
            if isempty(app.Image)
                msgbox('No base image loaded. Please load an image first.', 'Error', 'error');
                return;
            end
            [file, path] = uigetfile({'*.jpg;*.png;*.bmp;*.tiff', 'Image Files'});
            if file == 0
                return;
            end
            app.SecondImage = imread(fullfile(path, file));
            method = app.CombineMethodDropDown.Value;
            if strcmp(method, 'Side-by-side')
                app.Image = [imresize(app.Image, [size(app.SecondImage,1), size(app.Image,2)]), app.SecondImage];
            elseif strcmp(method, 'Overlay')
                app.SecondImage = imresize(app.SecondImage, size(app.Image));
                app.Image = uint8(double(app.Image) * 0.5 + double(app.SecondImage) * 0.5);
            end
            app.updateImage();
        end
    end

    % App initialization
    methods (Access = private)

        % UIFigure and components
        function createComponents(app)
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'Image Processing App';

            app.UIAxes = uiaxes(app.UIFigure);
            app.UIAxes.Position = [220 60 400 400];

            app.BrowseButton = uibutton(app.UIFigure, 'push');
            app.BrowseButton.ButtonPushedFcn = createCallbackFcn(app, @BrowseButtonPushed, true);
            app.BrowseButton.Position = [20 440 100 22];
            app.BrowseButton.Text = 'Browse';

            app.SaveImageButton = uibutton(app.UIFigure, 'push');
            app.SaveImageButton.ButtonPushedFcn = createCallbackFcn(app, @SaveImageButtonPushed, true);
            app.SaveImageButton.Position = [20 400 100 22];
            app.SaveImageButton.Text = 'Save Image';

            app.SaveFormatDropDown = uidropdown(app.UIFigure);
            app.SaveFormatDropDown.Items = {'jpg', 'png', 'bmp', 'tiff'};
            app.SaveFormatDropDown.Position = [130 400 80 22];
            app.SaveFormatDropDown.Value = 'jpg';

            app.ImageInfoButton = uibutton(app.UIFigure, 'push');
            app.ImageInfoButton.ButtonPushedFcn = createCallbackFcn(app, @ImageInfoButtonPushed, true);
            app.ImageInfoButton.Position = [20 360 100 22];
            app.ImageInfoButton.Text = 'Image Info';

            app.ConvertToBWButton = uibutton(app.UIFigure, 'push');
            app.ConvertToBWButton.ButtonPushedFcn = createCallbackFcn(app, @ConvertToBWButtonPushed, true);
            app.ConvertToBWButton.Position = [20 320 100 22];
            app.ConvertToBWButton.Text = 'Convert to B&W';

            app.CropImageButton = uibutton(app.UIFigure, 'push');
            app.CropImageButton.ButtonPushedFcn = createCallbackFcn(app, @CropImageButtonPushed, true);
            app.CropImageButton.Position = [20 280 100 22];
            app.CropImageButton.Text = 'Crop Image';

            app.ResizeImageButton = uibutton(app.UIFigure, 'push');
            app.ResizeImageButton.ButtonPushedFcn = createCallbackFcn(app, @ResizeImageButtonPushed, true);
            app.ResizeImageButton.Position = [20 240 100 22];
            app.ResizeImageButton.Text = 'Resize Image';

            app.FlipImageButton = uibutton(app.UIFigure, 'push');
            app.FlipImageButton.ButtonPushedFcn = createCallbackFcn(app, @FlipImageButtonPushed, true);
            app.FlipImageButton.Position = [20 200 100 22];
            app.FlipImageButton.Text = 'Flip Image';

            app.FlipDirectionDropDown = uidropdown(app.UIFigure);
            app.FlipDirectionDropDown.Items = {'Horizontal', 'Vertical'};
            app.FlipDirectionDropDown.Position = [130 200 80 22];
            app.FlipDirectionDropDown.Value = 'Horizontal';

            app.CombineImagesButton = uibutton(app.UIFigure, 'push');
            app.CombineImagesButton.ButtonPushedFcn = createCallbackFcn(app, @CombineImagesButtonPushed, true);
            app.CombineImagesButton.Position = [20 160 100 22];
            app.CombineImagesButton.Text = 'Combine Images';

            app.CombineMethodDropDown = uidropdown(app.UIFigure);
            app.CombineMethodDropDown.Items = {'Side-by-side', 'Overlay'};
            app.CombineMethodDropDown.Position = [130 160 80 22];
            app.CombineMethodDropDown.Value = 'Side-by-side';
        end
    end

    % App creation and deletion
    methods (Access = public)
        function app = ImageProcessingApp
            createComponents(app)
            registerApp(app, app.UIFigure)

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