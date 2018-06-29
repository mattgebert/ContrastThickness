function imColourBar(colours)

clrsize = size(colours);
k = clrsize(1);

cmap = colours/255.0;
colormap(cmap);
labels = cell(k,1);
for i=1:k
    labels(i) = cellstr(['Colour ', int2str(floor(i))]);
end
colorbar('Ticks', linspace(1/(2*k),1-1/(2*k),k),...
    'TickLabels',labels);