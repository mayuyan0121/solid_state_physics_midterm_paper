function export_all_figures_A_deep(figs, params)
%EXPORT_ALL_FIGURES_A_DEEP Export figures as PDF and PNG.
if ~exist(params.outdir, "dir"); mkdir(params.outdir); end
names = fieldnames(figs);
for i = 1:numel(names)
    name = names{i};
    fig = figs.(name);
    set(findall(fig, "-property", "FontName"), "FontName", "Arial");
    set(findall(fig, "-property", "TickDir"), "TickDir", "out");
    set(fig, "PaperPositionMode", "auto");
    pdfMode = "vector";
    if params.export_pdf
        exportgraphics(fig, fullfile(params.outdir, string(name) + ".pdf"), "ContentType", pdfMode);
    end
    if params.export_png
        exportgraphics(fig, fullfile(params.outdir, string(name) + ".png"), "Resolution", params.png_dpi);
    end
end
end
