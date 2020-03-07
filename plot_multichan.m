function plot_multichan( x, y, interval, normalize )
% Simple MATLAB function for plot multi-channel time-series data
% 
% Usage:
%    plot_multichan( y )    % <- y: signal
%    plot_multichan( x, y ) % <- x: time
% 
% Example: 
%    y = randn([20, 2000]); 
%    plot_multichan(y);
%
% Written by Hio-Been han, hiobeen.han@kaist.ac.kr, 2020-03-07
% 

% parse arguments
if nargin==1, y=x; x = 1:length(y); end
nChan = size(y,1);
if nChan > size(y,2),  y = y'; nChan = size(y,1); end
if nargin < 4, normalize = 1; end
if normalize
    stds = nanstd( y, 0, 2 );
    for chIdx = 1:size(y,1), y(chIdx,:) = nanmean(stds) * (y(chIdx,:) / stds(chIdx)); end
end
if nargin < 3
    interval = nanmean(range(y, 2)) * nChan / 2.5;
end
y_center = linspace( -interval, interval, nChan );

% set colormap
color_template =...
   [843 088 153;
    992 750 280;
    400 200 030;
    573 716 350;
    055 538 083]*.001;
c_space = repmat( color_template, [ ceil( nChan/size(color_template,1)), 1]);
% c_space=imresize(colormap('lines'),[nChan,3],'nearest');

% main plot
chanlab = {}; chanlab_pos = [];
lw = 1;
for chanIdx = 1:nChan
    shift = y_center(chanIdx) + nanmean( y( chanIdx, : ), 2);
    plot( x, y( chanIdx, : ) - shift, 'Color', c_space( chanIdx,: ) , 'LineWidth', lw); 
    chanIdx_reverse = nChan-chanIdx+1;
    chanlab{chanIdx} = sprintf( 'Ch %02d', chanIdx_reverse);
    chanlab_pos(chanIdx) =  y_center(chanIdx) ;
    if chanIdx ==1, hold on; end
end
hold off;

% enhance visibility
set(gca, 'YTick', chanlab_pos, 'YTickLabel', chanlab,...
    'Clipping', 'on', 'Box', 'off', 'LineWidth', 2);
ylim([-1 1]*interval*1.2);
