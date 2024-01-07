using System;
using System.IO;

namespace VSYSImgOps.SVG
{
    public sealed class SVGObject
    {
        public string FullPath { get; private set; }
        public string Filename { get; private set; }
        public string Filepath { get; private set; }
        public double ViewboxWidth { get; private set; }
        public double ViewboxHeight { get; private set; }
        public double WidthTag { get; private set; }
        public double HeightTag { get; private set; }
        public double ViewboxAspectRatio { get; private set; }
        public double TagAspectRatio { get; private set; }

        public SVGObject(string svgPath, double vbWidth, double vbHeight, double widthTag, double heightTag)
        {
            FullPath      = svgPath;
            ViewboxWidth  = vbWidth;
            ViewboxHeight = vbHeight;
            WidthTag      = widthTag;
            HeightTag     = heightTag;

            ViewboxAspectRatio = CalculateAspectRatio(ViewboxWidth, ViewboxHeight);
            TagAspectRatio     = CalculateAspectRatio(WidthTag, HeightTag);

            Filename = System.IO.Path.GetFileName(FullPath) ?? 
                throw new InvalidOperationException("FullPath does not contain a file name.");
            Filepath = System.IO.Path.GetDirectoryName(FullPath) 
                ?? throw new InvalidOperationException("FullPath does not contain a directory name.");
        }

        private static double CalculateAspectRatio(double width, double height)
        {
            if (height == 0 | width == 0) {
                return 0;
            }

            double aspectRatio = width / height;
            return aspectRatio;
        }

    }
}
