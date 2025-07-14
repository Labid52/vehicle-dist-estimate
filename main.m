%% Initialize variables
close all
clear
clc
tic

% Number of stereo images in the source
nimages = 100; % Total number of images (e.g., 100)

% Load stereo parameters
load stereoParams

% Set range for disparity and point cloud
disparityRange = [0 64];
thresholds = [-5 5; -5 10; 0 30]; 
lb = 10;
ub = 30;
withoutFilter = [4, 5, 6, 8, 9, 10, 12, 14, 17, 18, 19, 21, 22, 23, 24, 25, 26, 27, 28, ...
    29, 30, 32, 40, 53, 56, 57, 58, 60, 61, 62, 65, 71, 77, 93];
failedD = [20 49 67 68 69 70 72 73 74];
Iseg = containers.Map; % result from image segmentation
Iseg('20') = [754 252; 752 295; 810 296; 812 252];
Iseg('49') = [772 253; 772 294; 822 294; 822 255];
Iseg('67') = [746 242; 739 332; 835 329; 836 239];
Iseg('68') = [747 250; 742 339; 852 337; 841 250];
Iseg('69') = [747 248; 746 340; 857 341; 853 241];
Iseg('70') = [750 252; 750 336; 851 337; 848 248];
Iseg('72') = [739 245; 734 330; 835 327; 829 239];
Iseg('73') = [707 249; 707 326; 785 325; 784 246];
Iseg('74') = [[683 264; 678 328; 756 329; 757 263],[781 279; 782 309; 841 313; 832 279]];

Mask1 = [0 0 0 1 1 1 0 1 1 1 0 1 2 1 0 0 1 1 1 3 1 1 1 1 1 1 1 1 1 1 0 1 ... 
0 2 5 3 3 3 5 1 2 3 3 0 3 3 0 6 3 7 ...
4 0 1 0 0 1 1 1 0 1 1 1 0 4 1 0 3 3 3 3 1 3 3 3 0 0 1 0 8 4 2 4 0 0 2 ... 
0 2 4 4 0 4 4 1 0 0 4 4 4 2 2];

% Create DeployableVideoPlayer for visualization
VP = vision.DeployableVideoPlayer;

% Create output directory for saved frames
outputDir = 'saved_frames';  
if ~exist(outputDir, 'dir')
    mkdir(outputDir);  % Create directory if it doesn't exist
end

for frameIdx = 1:1  % Loop through all frames
    %% Load stereo images
    [IL, IR] = returnStereoImages(frameIdx);

    %% Enhancement
    IL_f = imsharpen(IL);
    IR_f = imsharpen(IR);
    if Mask1(frameIdx) == 0
        IL_f = imadjust(IL_f, stretchlim(IL, [0.05, 0.95]), []);
        IR_f = imadjust(IR_f, stretchlim(IR, [0.05, 0.95]), []);
        IL_f = immultiply(IL_f, 1.5);
        IR_f = immultiply(IR_f, 1.5);
        IL_f = 4 * (((1 + 0.1).^(IL_f)) - 1);
        IR_f = 4 * (((1 + 0.1).^(IR_f)) - 1);
    elseif Mask1(frameIdx) == 1
        IL_f = IL;
        IR_f = IR;
    elseif Mask1(frameIdx) == 2
        IL_f = 2 * log(1 + im2double(IL_f));
        IR_f = 2 * log(1 + im2double(IR_f));
    elseif Mask1(frameIdx) == 3
        IL_f = IL;
        IR_f = IR;
    elseif Mask1(frameIdx) == 4
        IL_f = imadjust(IL_f, stretchlim(IL, [0.05, 0.95]), []);
        IR_f = imadjust(IR_f, stretchlim(IR, [0.05, 0.95]), []);
        IL_f = immultiply(IL_f, 1.5);
        IR_f = immultiply(IR_f, 1.5);
        IL_f = 4 * (((1 + 0.2).^(IL_f)) - 1);
        IR_f = 4 * (((1 + 0.2).^(IR_f)) - 1);
    elseif Mask1(frameIdx) == 5
        IL_f = 5 * log(1 + im2double(IL_f));
        IR_f = 5 * log(1 + im2double(IR_f));
    elseif Mask1(frameIdx) == 6
        IL_f = imadjust(IL_f, stretchlim(IL, [0.05, 0.95]), []);
        IR_f = imadjust(IR_f, stretchlim(IR, [0.05, 0.95]), []);
        IL_f = immultiply(IL_f, 1.5);
        IR_f = immultiply(IR_f, 1.5);
        IL_f = 4 * (((1 + 0.5).^(IL_f)) - 1);
        IR_f = 4 * (((1 + 0.5).^(IR_f)) - 1);
    elseif Mask1(frameIdx) == 7
        IL_f = imadjust(IL_f, stretchlim(IL, [0.05, 0.95]), []);
        IR_f = imadjust(IR_f, stretchlim(IR, [0.05, 0.95]), []);
        IL_f = immultiply(IL_f, 1.5);
        IR_f = immultiply(IR_f, 1.5);
        IL_f = 4 * (((1 + 0.3).^(IL_f)) - 1);
        IR_f = 4 * (((1 + 0.3).^(IR_f)) - 1);
    elseif Mask1(frameIdx) == 8
        IL_f = imadjust(IL_f, stretchlim(IL, [0.05, 0.95]), []);
        IR_f = imadjust(IR_f, stretchlim(IR, [0.05, 0.95]), []);
        IL_f = immultiply(IL_f, 1.5);
        IR_f = immultiply(IR_f, 1.5);
        IL_f = 4 * (((1 + 0.4).^(IL_f)) - 1);
        IR_f = 4 * (((1 + 0.4).^(IR_f)) - 1);
    end

    %% Rectify the Images
    [JL, JR] = rectifyStereoImages(IL_f, IR_f, stereoParams);
    [JL1, JR1] = rectifyStereoImages(IL, IR, stereoParams); 

    %% Generate Disparity Map
    disparityMap = disparity(rgb2gray(JL), rgb2gray(JR), 'DisparityRange', disparityRange);

    %% Reconstruct Point Cloud
    ptCloud = reconstructScene(disparityMap, stereoParams);
    ptCloud = ptCloud / 1000;  % Convert from mm to meters
    ptCloud = thresholdPC(ptCloud, thresholds);
    Z = ptCloud(:,:,3);
    mask = repmat(Z > lb & Z < ub, [1, 1, 3]);
    KL = JL;
    KL(~mask) = 0;

    %% Object detection
    if ismember(frameIdx, failedD) == 0
        COD = vision.CascadeObjectDetector('CarDetector.xml', 'UseROI', true);
        [nr, nc, ~] = size(JL);
        xleft = 380;
        yupper = 160;
        roi = [xleft yupper nc - 2 * xleft nr - yupper + 1];
        frame = insertObjectAnnotation(JL, 'rectangle', roi, 'ROI');  % title
        bboxes = step(COD, JL, roi);
    elseif ismember(frameIdx, failedD) == 1
        dd = Iseg(string(frameIdx));
        bboxes = [dd(1, 1) dd(1, 2) dd(3, 1) - dd(1, 1) dd(3, 2) - dd(1, 2)];
    end

    %% Distance estimation
    [nb, n_point, ~] = size(bboxes);
    if nb == 1
        x1 = bboxes(:, 1);
        x2 = bboxes(:, 1) + bboxes(:, 3);
        y1 = bboxes(:, 2);
        y2 = bboxes(:, 2) + bboxes(:, 4);
        ptCloudZRoi = ptCloud(y1:y2, x1:x2, 3);
        distance = mean(ptCloudZRoi(:), 'omitnan');
        label = distance;
        frame = insertObjectAnnotation(JL1, 'rectangle', bboxes, num2str(distance));
        imshow(frame)
        title(strcat('Distance estimation frame #: ', string(frameIdx)));
    else
        label = zeros(1, nb);
        for i = 1:nb
            x1(i, :) = bboxes(i, 1);
            x2(i, :) = bboxes(i, 1) + bboxes(i, 3);
            y1(i, :) = bboxes(i, 2);
            y2(i, :) = bboxes(i, 2) + bboxes(i, 4);
            ptCloudZRoi = ptCloud(y1(i):y2(i), x1(i):x2(i), 3);
            distance(i) = mean(ptCloudZRoi(:), 'omitnan');
            label(i) = distance(i);
            frame = insertObjectAnnotation(JL1, 'rectangle', bboxes, label);
            imshow(frame)
            title(strcat('Distance estimation frame #: ', string(frameIdx)));
        end
    end

    if isempty(label) == 0
        dist(:, frameIdx) = min(label);
    else
        dist(:, frameIdx) = nan;
    end

    % Save the frame to output directory
    frameFileName = fullfile(outputDir, sprintf('frame_%03d.jpg', frameIdx));
    imwrite(frame, frameFileName);  % Save the frame after processing
end

%% Clean up
release(VP)
toc
