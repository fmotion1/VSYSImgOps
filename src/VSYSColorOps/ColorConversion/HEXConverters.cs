using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using VSYSColorOps.ColorConversion;

namespace VSYSColorOps.ColorConversion
{
    public class HEXConverters
    {
        
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

        public static (byte R, byte G, byte B) HexToRGBByte(string hex)
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
            var (r, g, b) = HexToRGBByte(hex);
            return RGBConverters.RGBByteToCMYKFloat(r, g, b);
        }

        public static (float C, float M, float Y, float K) HexToCMYKPercentage(string hex)
        {
            var (r, g, b) = HexToRGBByte(hex);
            return RGBConverters.RGBByteToCMYKPercentage(r, g, b);
        }

        public static (float H, float S, float V) HexToHSVFloat(string hex)
        {
            var (r, g, b) = HexToRGBByte(hex);
            return RGBConverters.RGBByteToHSVFloat(r, g, b);
        }
    }
}
