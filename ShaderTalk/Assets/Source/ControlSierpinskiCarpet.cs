using UnityEngine;
using System.Collections;


namespace Bears
{
	public class ControlSierpinskiCarpet : MonoBehaviour 
	{
		public Renderer carpetRenderer;

		public float speed = 10.0f;
		public float amplitude = 10.0f;

		public float minValue = 0;
		public float maxValue = 40;

		public float startingValue { protected set; get; }


		void Awake ()
		{
			if ( this.carpetRenderer == null )
			{
				this.carpetRenderer = GetComponent < Renderer > ();
			}
		}

		void Start () 
		{
			if ( this.carpetRenderer != null )
			{
				this.startingValue = this.carpetRenderer.material.GetFloat ( "_Power" );
			}
		}

		void FixedUpdate () 
		{
			if ( this.carpetRenderer )
			{
				float value = this.startingValue + Mathf.Sin ( Time.time * this.speed ) * this.amplitude;
				value = Mathf.Clamp( value, this.minValue, this.maxValue );
				this.carpetRenderer.material.SetFloat ( "_Power", value );

				//Debug.Log ( "Carpet power: " + value );
			}
		}
	}
}
