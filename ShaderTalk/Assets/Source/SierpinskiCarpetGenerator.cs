using UnityEngine;
using System.Collections;



public class SierpinskiCarpetGenerator : MonoBehaviour 
{
	public Renderer targetRenderer;
	public Texture2D texture;

	public int textureWidth = 512;
	public int textureHeight = 512;

	[Range(2, 20)]
	public int power = 10;


	void Awake ()
	{
		if ( this.targetRenderer == null )
		{
			this.targetRenderer = GetComponent < Renderer > ();
		}
	}


	// Use this for initialization
	void Start () 
	{
		this.texture = GenerateTexture ();
		if ( this.texture && this.targetRenderer )
		{
			this.targetRenderer.material.SetTexture ( "_MainTex", this.texture );
		}
	}


	// Update is called once per frame
	void Update () 
	{
	
	}


	public virtual Texture2D GenerateTexture ()
	{
		// Create a new 2x2 texture ARGB32 (32 bit with alpha) and no mipmaps
		Texture2D texture = new Texture2D ( this.textureWidth, this.textureHeight, TextureFormat.ARGB32, false );

		float colorValue;

		int pow = (int)Mathf.Pow ( 3, this.power );

		// Generate texture
		for ( int x = 0; x < this.textureWidth; x++ )
		{
			for ( int y = 0; y < this.textureHeight; y++ )
			{
				if ( IsSierpinskiCarpetPixelFilled ( x * pow, y * pow ) )
				{
					colorValue = 0;
				}
				else
				{
					colorValue = 255;
				}
				texture.SetPixel ( x, y, new Color ( colorValue, colorValue, colorValue, 1.0f ) );
			}
		}
		
		// Apply all SetPixel calls
		texture.Apply();
		
		return texture;
	}

	
	/// <summary>
	/// Decides if a point at a specific location is filled or not.  This works by iteration first checking if
	/// the pixel is unfilled in successively larger squares or cannot be in the center of any larger square.
	/// </summary>
	/// <returns>The sierpinski carpet pixel filled.</returns>
	/// <param name="x">The x coordinate of the point being checked with zero being the first pixel.</param>
	/// <param name="y">The y coordinate of the point being checked with zero being the first pixel.</param>
	protected bool IsSierpinskiCarpetPixelFilled( int x, int y )
	{
		// when either of these reaches zero the pixel is determined to be on the edge 
		// at that square level and must be filled
		while ( x > 0 || y > 0 )
		{
			//checks if the pixel is in the center for the current square level
			if ( x%3 == 1 && y%3 == 1 )
			{
				return false;
			}

			x /= 3; //x and y are decremented to check the next larger square level
			y /= 3;
		}

		return true; // if all possible square levels are checked and the pixel is not determined 
		// to be open it must be filled
	}
}
