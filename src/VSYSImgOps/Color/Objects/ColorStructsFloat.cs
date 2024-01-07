using System;
using System.Globalization;
using System.Text.RegularExpressions;

/// <summary>
/// The VSYSColorOps.ColorStructs namespace contains color-related struct definitions used for various color operations in the Visual System (VSYS) project.
/// </summary>
namespace VSYSImgOps.Color.Objects
{

    /// <summary>
    /// Represents a color using red, green, and blue channels where the values range from 0 to 1.
    /// </summary>
    public sealed class RGBFloat
    {
        /// <summary>
        /// Gets the value of the red channel ranging from 0 to 1.
        /// </summary>
        public double Red { get; }
    
        /// <summary>
        /// Gets the value of the green channel ranging from 0 to 1.
        /// </summary>
        public double Green { get; }
    
        /// <summary>
        /// Gets the value of the blue channel ranging from 0 to 1.
        /// </summary>
        public double Blue { get; }
    
        /// <summary>
        /// Initializes a new instance of the RGBFloat class with specified red, green, and blue channel values.
        /// </summary>
        /// <param name="red">The red channel value (0-1).</param>
        /// <param name="green">The green channel value (0-1).</param>
        /// <param name="blue">The blue channel value (0-1).</param>
        /// <exception cref="ArgumentOutOfRangeException">
        ///     Thrown when any of the input parameters are less than 0 or greater than 1.
        /// </exception>
        public RGBFloat(double red, double green, double blue)
        {
            if(red > 1 || red < 0)
                throw new ArgumentOutOfRangeException(nameof(red),
                "Red channel is out of bounds (0-1).");
    
            if(green > 1 || green < 0)
                throw new ArgumentOutOfRangeException(nameof(green),
                "Green channel is out of bounds (0-1).");
    
            if(blue > 1 || blue < 0)
                throw new ArgumentOutOfRangeException(nameof(blue),
                "Blue channel is out of bounds (0-1).");
    
            Red = red;
            Green = green;
            Blue = blue;
        }
    
        /// <summary>
        /// Returns a string that represents the current object.
        /// </summary>
        /// <returns>A string in the format "(red,green,blue)".</returns>
        public override string ToString()
        {
            return $"({Red},{Green},{Blue})";
        }
    }


    /// <summary>
    /// Defines a RGBA color using floating point values between 0 and 1.
    /// </summary>
    public sealed class RGBAFloat
    {
        /// <summary>
        /// Gets the Red component of the color.
        /// </summary>
        public double Red { get; }
    
        /// <summary>
        /// Gets the Green component of the color.
        /// </summary>
        public double Green { get; }
    
        /// <summary>
        /// Gets the Blue component of the color.
        /// </summary>
        public double Blue { get; }
    
        /// <summary>
        /// Gets the Alpha transparency level of the color.
        /// </summary>
        public double Alpha { get; }
    
    
        /// <summary>
        /// Initializes a new instance of the RGBAFloat class.
        /// </summary>
        /// <param name="red">The red component of the color. Must be between 0 and 1.</param>
        /// <param name="green">The green component of the color. Must be between 0 and 1.</param>
        /// <param name="blue">The blue component of the color. Must be between 0 and 1.</param>
        /// <param name="alpha">The alpha transparency level of the color. Must be between 0 and 1.</param>
        /// <exception cref="ArgumentOutOfRangeException">
        /// Thrown when any of the parameters are less than 0 or greater than 1.
        /// </exception>
        public RGBAFloat(double red, double green, double blue, double alpha)
        {
            if(red > 1 || red < 0)
                throw new ArgumentOutOfRangeException(nameof(red),
                "Red channel is out of bounds (0-1).");

            if(green > 1 || green < 0)
                throw new ArgumentOutOfRangeException(nameof(green),
                "Green channel is out of bounds (0-1).");

            if(blue > 1 || blue < 0)
                throw new ArgumentOutOfRangeException(nameof(blue),
                "Blue channel is out of bounds (0-1).");

            if(alpha > 1 || alpha < 0)
                throw new ArgumentOutOfRangeException(nameof(alpha),
                "Alpha channel is out of bounds (0-1).");

            Red = red;
            Green = green;
            Blue = blue;
            Alpha = alpha;
        }
    
        /// <summary>
        /// Returns a string representation of the RGBAFloat in the format (red,green,blue,alpha).
        /// </summary>
        /// <returns>A string representing the color.</returns>
        public override string ToString()
        {
            return $"({Red},{Green},{Blue},{Alpha})";
        }
    }
}
