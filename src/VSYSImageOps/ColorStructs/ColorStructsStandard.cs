using System;
using System.Globalization;
using System.Text.RegularExpressions;

namespace VSYSColorOps.ColorStructs
{

    public sealed class CMYK
    {
        public int Cyan { get; }
        public int Magenta { get; }
        public int Yellow { get; }
        public int Key { get; }

        public CMYK(int cyan, int magenta, int yellow, int key)
        {
            if(cyan > 100 || cyan < 0)
                throw new ArgumentOutOfRangeException(nameof(cyan),
                "Cyan is out of bounds (0-100)");

            if(magenta > 100 || magenta < 0)
                throw new ArgumentOutOfRangeException(nameof(magenta),
                "Magenta is out of bounds (0-100)");

            if(yellow > 100 || yellow < 0)
                throw new ArgumentOutOfRangeException(nameof(yellow),
                "Yellow is out of bounds (0-100)");

            if(key > 100 || key < 0)
                throw new ArgumentOutOfRangeException(nameof(key),
                "Key is out of bounds (0-100)");

            Cyan = cyan;
            Magenta = magenta;
            Yellow = yellow;
            Key = key;
        }

        public override string ToString()
        {
            return "(" + Cyan + "," + Magenta + "," + Yellow + "," + Key + ")";
        }

    }

    public sealed class HSL
    {
        public int Hue { get; }
        public int Saturation { get; }
        public int Lightness { get; }

        public HSL(int hue, int sat, int lightness)
        {
            if(hue > 359 || hue < 0)
                throw new ArgumentOutOfRangeException(nameof(hue),
                "Hue is out of bounds (0-359)");

            if(sat > 100 || sat < 0)
                throw new ArgumentOutOfRangeException(nameof(sat),
                "Saturation is out of bounds (0-359)");

            if(lightness > 100 || lightness < 0)
                throw new ArgumentOutOfRangeException(nameof(lightness),
                "Lightness is out of bounds (0-359)");

            Hue = hue;
            Saturation = sat;
            Lightness = lightness;
        }

        public override string ToString()
        {
            return "(" + Hue + "," + Saturation + "," + Lightness + ")";
        }
    }

    public sealed class HSV
    {

        public int Hue { get; }
        public int Saturation { get; }
        public int Value { get; }



        public HSV(int hue, int sat, int val)
        {
            if(hue > 359 || hue < 0)
                throw new ArgumentOutOfRangeException(nameof(hue),
                "Hue is out of bounds (0-359)");

            if(sat > 100 || sat < 0)
                throw new ArgumentOutOfRangeException(nameof(sat),
                "Saturation is out of bounds (0-100)");

            if(val > 100 || val < 0)
                throw new ArgumentOutOfRangeException(nameof(val),
                "Value is out of bounds (0-100)");

            Hue = hue;
            Saturation = sat;
            Value = val;
        }

        public override string ToString()
        {
            return "(" + Hue + "," + Saturation + "," + Value + ")";
        }
    }

    public sealed class RGB
    {
        public byte Red { get; }
        public byte Green { get; }
        public byte Blue { get; }

        public RGB() { }

        public RGB(byte red, byte green, byte blue)
        {
            Red = red;
            Green = green;
            Blue = blue;
        }

        public override string ToString()
        {
            return "(" + Red + "," + Green + "," + Blue + ")";
        }

    }

    public sealed class RGBA
    {
        public byte Red { get; }
        public byte Green { get; }
        public byte Blue { get; }
        public byte Alpha { get; }

        public RGBA() { }

        public RGBA(byte red, byte green, byte blue, byte alpha)
        {
            Red = red;
            Green = green;
            Blue = blue;
            Alpha = alpha;
        }

        public override string ToString()
        {
            return "(" + Red + "," + Green + "," + Blue + "," + Alpha + ")";
        }

    }

    public sealed class HTMLHex
    {

        public string Hex { get; }

        public HTMLHex(string hex)
        {
            if (!Regex.IsMatch(hex, "^#([A-Fa-f0-9]{6})$"))
                throw new ArgumentException("Hex is malformed.");

            Hex = hex;
        }

        public override string ToString()
        {
            return Hex;
        }

    }

    public sealed class HTMLHexAlpha
    {

        public string Hex { get; }

        public HTMLHexWithAlpha(string hex)
        {
            if (!Regex.IsMatch(hex, "^#([0-9A-Fa-f]{6})([0-9A-Fa-f]{2})$"))
                throw new ArgumentException("Hex is malformed.");

            Hex = hex;
        }

        public override string ToString()
        {
            return Hex;
        }

    } 
}
