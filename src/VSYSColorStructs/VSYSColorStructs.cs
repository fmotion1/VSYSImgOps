using System;
using System.Text.RegularExpressions;

namespace VSYSColorStructs
{
    public struct CMYKColor
    {
        public int Cyan { get; }
        public int Magenta { get; }
        public int Yellow { get; }
        public int Key { get; }

        public CMYKColor(int c, int m, int y, int k)
        {
            if(c > 100 || c < 0) {
                throw new ArgumentException("Cyan is out of bounds (0-100)");
            }
            if(m > 100 || m < 0) {
                throw new ArgumentException("Magenta is out of bounds (0-100)");
            }
            if(y > 100 || y < 0) {
                throw new ArgumentException("Yellow is out of bounds (0-100)");
            }
            if(k > 100 || k < 0) {
                throw new ArgumentException("Key is out of bounds (0-100)");
            }
            Cyan = c;
            Magenta = m;
            Yellow = y;
            Key = k;
        }
    }

    public struct HSLColor
    {
        public int Hue { get; }
        public int Saturation { get; }
        public int Lightness { get; }

        public HSLColor(int h, int s, int l)
        {
            if(h > 300 || h < 0) {
                throw new ArgumentException("Hue is out of bounds (0-300)");
            }
            if(s > 100 || s < 0) {
                throw new ArgumentException("Saturation is out of bounds (0-100)");
            }
            if(l > 100 || l < 0) {
                throw new ArgumentException("Lightness is out of bounds (0-100)");
            }

            Hue = h;
            Saturation = s;
            Lightness = l;
        }
    }

    public struct HSVColor
    {
        public int Hue { get; }
        public int Saturation { get; }
        public int Value { get; }

        public HSVColor(int h, int s, int v)
        {
            if(h > 300 || h < 0) {
                throw new ArgumentException("Hue is out of bounds (0-300)");
            }
            if(s > 100 || s < 0) {
                throw new ArgumentException("Saturation is out of bounds (0-100)");
            }
            if(v > 100 || v < 0) {
                throw new ArgumentException("Value is out of bounds (0-100)");
            }

            Hue = h;
            Saturation = s;
            Value = v;
        }
    }

    public struct RGBColor
    {
        public byte R { get; }
        public byte G { get; }
        public byte B { get; }

        public RGBColor() { }

        public RGBColor(byte r, byte g, byte b)
        {
            R = r;
            G = g;
            B = b;
        }
    }

    public struct HexColor
    {

        public string Hex { get; }

        public HexColor(string h)
        {
            if (!Regex.IsMatch(h, "[#][0-9A-Fa-f]{6}")) {
                throw new ArgumentException("Supplied HEX color is malformed.");
            }
            Hex = h;
        }

    }
}
