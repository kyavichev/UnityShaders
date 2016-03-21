using UnityEngine;
using System.Collections;


namespace Bears
{
	public class AroundPointRotator : MonoBehaviour 
	{
		public float speed = 20;
		public float maxSpeed = 20;
		public float minSpeed = 0;
		public bool enableSpeedDrag = false;
		public float speedDrag = 0.5f;
		public Vector3 point = Vector3.zero;
		public Vector3 axis = Vector3.up;
		public bool local = false;

		public bool randomizeAxis = false;
		public float axisRandomizationFrequency = 0.3f;
		public float axisRandomizationCtrl { protected set; get; }

		void FixedUpdate() 
		{
			Vector3 newAxis = this.axis;
			if ( this.randomizeAxis )
			{
				this.axisRandomizationCtrl += Time.deltaTime;
				if ( this.axisRandomizationCtrl > this.axisRandomizationFrequency )
				{
					newAxis.x = Random.Range ( -this.axis.x, this.axis.x );
					newAxis.y = Random.Range ( -this.axis.y, this.axis.y );
					newAxis.z = Random.Range ( -this.axis.z, this.axis.z );

					this.axisRandomizationCtrl = 0;
				}
			}

			if ( this.local == false )
			{
				this.transform.RotateAround ( this.point, newAxis, this.speed * Time.deltaTime );
			}
			else
			{
				this.transform.RotateAround ( this.gameObject.transform.position, newAxis, this.speed * Time.deltaTime); 
			}
		}
	}
}
