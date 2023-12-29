using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using VSYSImgOps.Color;

namespace VSYSImgOps.Color
{
    public static class Converters
    {

        // HEX CONVERTERS ///////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////

        public static (float R, float G, float B) HexToRGBFloat(string hex)
        {
            // Remove '#' if it exists
            if (hex.StartsWith("#"))
            {
                hex = hex.Substring(1);
            }
        
            // Check if valid hex color
            if (!int.TryParse(hex, NumberStyles.HexNumber, CultureInfo.InvariantCulture, out int intColor))
            {
                throw new ArgumentException($"{hex} is not a valid hex color value");
            }
        
            // Convert hex to int and extract RGB components
            float r = ((intColor >> 16) & 255) / 255f;
            float g = ((intColor >> 8) & 255) / 255f;
            float b = (intColor & 255) / 255f;
        
            return (r, g, b);
        }

        public static (byte R, byte G, byte B) HexToRGB255(string hex)
        {
            // Remove '#' if it exists
            if (hex.StartsWith("#"))
            {
                hex = hex.Substring(1);
            }

            // Convert hex to int and extract RGB components
            int intColor = int.Parse(hex, NumberStyles.HexNumber);
            byte r = (byte)((intColor >> 16) & 255);
            byte g = (byte)((intColor >> 8) & 255);
            byte b = (byte)(intColor & 255);

            return (r, g, b);
        }

        public static (float C, float M, float Y, float K) HexToCMYKFloat(string hex)
        {
            var (r, g, b) = HexToRGB255(hex);
            return Converters.RGB255ToCMYKFloat(r, g, b);
        }

        public static (float C, float M, float Y, float K) HexToCMYKPercentage(string hex)
        {
            var (r, g, b) = HexToRGB255(hex);
            return Converters.RGB255ToCMYKPercentage(r, g, b);
        }

        public static (float H, float S, float V) HexToHSVFloat(string hex)
        {
            var (r, g, b) = HexToRGB255(hex);
            return Converters.RGB255ToHSVFloat(r, g, b);
        }


        // RGB CONVERTERS ///////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////


        public static string RGBFloatToHex(float red, float green, float blue)
        {
            // Clamping the values between 0.0 and 1.0
            red = Math.Clamp(red, 0.0f, 1.0f);
            green = Math.Clamp(green, 0.0f, 1.0f);
            blue = Math.Clamp(blue, 0.0f, 1.0f);

            // Converting float values to integers in the 0-255 range
            int r = (int)(red * 255);
            int g = (int)(green * 255);
            int b = (int)(blue * 255);

            // Returning the formatted hex string
            return $"#{r:X2}{g:X2}{b:X2}";
        }

        public static (float H, float S, float L) RGBFloatToHSL(float r, float g, float b)
        {
            // Clamp the RGB values to ensure they are between 0.0 and 1.0
            r = Math.Clamp(r, 0.0f, 1.0f);
            g = Math.Clamp(g, 0.0f, 1.0f);
            b = Math.Clamp(b, 0.0f, 1.0f);

            float max = Math.Max(r, Math.Max(g, b));
            float min = Math.Min(r, Math.Min(g, b));
            float h, s, l;
            l = (max + min) / 2;

            if (max == min)
            {
                h = s = 0; // achromatic
            }
            else
            {
                float d = max - min;
                s = l > 0.5 ? d / (2 - max - min) : d / (max + min);

                if (max == r)
                {
                    h = (g - b) / d + (g < b ? 6 : 0);
                }
                else if (max == g)
                {
                    h = (b - r) / d + 2;
                }
                else // max == b
                {
                    h = (r - g) / d + 4;
                }

                h /= 6;
            }

            // Convert to degrees, percentage
            h = h * 360; // Hue in degrees
            s = s * 100; // Saturation in percentage
            l = l * 100; // Lightness in percentage

            return (h, s, l);
        }

        public static (float H, float S, float L) RGBFloatToHSLFloat(float r, float g, float b)
        {
            // Clamp the RGB values to ensure they are between 0.0 and 1.0
            r = Math.Clamp(r, 0.0f, 1.0f);
            g = Math.Clamp(g, 0.0f, 1.0f);
            b = Math.Clamp(b, 0.0f, 1.0f);

            float max = Math.Max(r, Math.Max(g, b));
            float min = Math.Min(r, Math.Min(g, b));
            float h, s, l;
            l = (max + min) / 2;

            if (max == min)
            {
                h = s = 0; // achromatic
            }
            else
            {
                float d = max - min;
                s = l > 0.5 ? d / (2 - max - min) : d / (max + min);

                if (max == r)
                {
                    h = (g - b) / d + (g < b ? 6 : 0);
                }
                else if (max == g)
                {
                    h = (b - r) / d + 2;
                }
                else
                {
                    h = (r - g) / d + 4;
                }

                h /= 6;
            }

            return (h, s, l);
        }

        public static (float H, float S, float V) RGBFloatToHSVFloat(float r, float g, float b)
        {
            // Clamp the RGB values to ensure they are between 0.0 and 1.0
            r = Math.Clamp(r, 0.0f, 1.0f);
            g = Math.Clamp(g, 0.0f, 1.0f);
            b = Math.Clamp(b, 0.0f, 1.0f);

            float max = Math.Max(r, Math.Max(g, b));
            float min = Math.Min(r, Math.Min(g, b));
            float h, s, v;
            v = max;

            float delta = max - min;
            s = max == 0 ? 0 : delta / max;

            if (max == min)
            {
                h = 0; // achromatic
            }
            else
            {
                if (max == r)
                {
                    h = (g - b) / delta + (g < b ? 6 : 0);
                }
                else if (max == g)
                {
                    h = (b - r) / delta + 2;
                }
                else
                {
                    h = (r - g) / delta + 4;
                }

                h /= 6;
            }

            return (h, s, v);
        }

        public static (float H, float S, float V) RGBFloatToHSV(float r, float g, float b)
        {
            // Clamp the RGB values to ensure they are between 0.0 and 1.0
            r = Math.Clamp(r, 0.0f, 1.0f);
            g = Math.Clamp(g, 0.0f, 1.0f);
            b = Math.Clamp(b, 0.0f, 1.0f);

            float max = Math.Max(r, Math.Max(g, b));
            float min = Math.Min(r, Math.Min(g, b));
            float h, s, v;
            v = max;

            float delta = max - min;
            s = max == 0 ? 0 : delta / max;

            if (max == min)
            {
                h = 0; // achromatic
            }
            else
            {
                if (max == r)
                {
                    h = (g - b) / delta + (g < b ? 6 : 0);
                }
                else if (max == g)
                {
                    h = (b - r) / delta + 2;
                }
                else
                {
                    h = (r - g) / delta + 4;
                }

                h /= 6;
            }

            // Convert to degrees and percentage
            h = h * 360; // Hue in degrees
            s = s * 100; // Saturation in percentage
            v = v * 100; // Value in percentage

            return (h, s, v);
        }

        public static (float C, float M, float Y, float K) RGBFloatToCMYKFloat(float r, float g, float b)
        {
            float k = 1 - Math.Max(Math.Max(r, g), b);

            if (k == 1)
            {
                return (0, 0, 0, 1); // Pure black
            }

            float c = (1 - r - k) / (1 - k);
            float m = (1 - g - k) / (1 - k);
            float y = (1 - b - k) / (1 - k);

            return (c, m, y, k);
        }

        public static (float C, float M, float Y, float K) RGBFloatToCMYKPercentage(float r, float g, float b)
        {
            // Ensure the RGB values are in the 0.0 to 1.0 range
            r = Math.Clamp(r, 0.0f, 1.0f);
            g = Math.Clamp(g, 0.0f, 1.0f);
            b = Math.Clamp(b, 0.0f, 1.0f);

            // Calculate Key (Black) value
            float k = 1 - Math.Max(Math.Max(r, g), b);

            if (k == 1)
            {
                return (0, 0, 0, 100); // Pure black
            }

            // Calculate Cyan, Magenta, Yellow values
            float c = (1 - r - k) / (1 - k) * 100;
            float m = (1 - g - k) / (1 - k) * 100;
            float y = (1 - b - k) / (1 - k) * 100;
            float kPercentage = k * 100;

            return (c, m, y, kPercentage);
        }

        public static string RGB255ToHex(byte red, byte green, byte blue)
        {
            // Returning the formatted hex string
            return $"#{red:X2}{green:X2}{blue:X2}";
        }

        public static (float H, float S, float V) RGB255ToHSVFloat(byte r, byte g, byte b)
        {
            float rf = r / 255f;
            float gf = g / 255f;
            float bf = b / 255f;

            float max = Math.Max(rf, Math.Max(gf, bf));
            float min = Math.Min(rf, Math.Min(gf, bf));
            float h, s, v;
            v = max;

            float delta = max - min;
            s = max == 0 ? 0 : delta / max;

            if (max == min)
            {
                h = 0; // Achromatic
            }
            else
            {
                if (max == rf)
                {
                    h = (gf - bf) / delta + (gf < bf ? 6 : 0);
                }
                else if (max == gf)
                {
                    h = (bf - rf) / delta + 2;
                }
                else
                {
                    h = (rf - gf) / delta + 4;
                }

                h /= 6;
            }

            return (h, s, v);
        }

        public static (float C, float M, float Y, float K) RGB255ToCMYKFloat(byte r, byte g, byte b)
        {
            float rf = r / 255f;
            float gf = g / 255f;
            float bf = b / 255f;

            return RGBFloatToCMYK(rf, gf, bf);
        }
        
        public static (float C, float M, float Y, float K) RGB255ToCMYKPercentage(byte r, byte g, byte b)
        {
            // Normalize the RGB values to the range 0.0 to 1.0
            float rf = r / 255f;
            float gf = g / 255f;
            float bf = b / 255f;

            // Calculate Key (Black) value
            float k = 1 - Math.Max(Math.Max(rf, gf), bf);

            if (k == 1)
            {
                return (0, 0, 0, 100); // Pure black
            }

            // Calculate Cyan, Magenta, Yellow values
            float c = (1 - rf - k) / (1 - k) * 100;
            float m = (1 - gf - k) / (1 - k) * 100;
            float y = (1 - bf - k) / (1 - k) * 100;
            float kPercentage = k * 100;

            return (c, m, y, kPercentage);
        }
    }
}
