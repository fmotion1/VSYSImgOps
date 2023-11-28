namespace VSYSColorStructs
{
    public class CMYKColor
    {
        public CMYKColor() { }
        public int? Cyan { get; set; }
        public int? Magenta { get; set; }
        public int? Yellow { get; set; }
        public int? Black { get; set; }
    }

    public class HSLColor
    {
        public HSLColor() { }
        public string? Hex { get; set; }
        public int? Hue { get; set; }
        public int? Saturation { get; set; }
        public int? Lightness { get; set; }
    }

    public class HSVColor
    {
        public HSVColor() { }
        public int? Hue { get; set; }
        public int? Saturation { get; set; }
        public int? Value { get; set; }
    }

    public class RGBColor
    {
        public RGBColor() { }
        public int? Red { get; set; }
        public int? Green { get; set; }
        public int? Blue { get; set; }
    }
    
}
