using UnityEngine;
using System.Collections;

public class Spawner : MonoBehaviour 
{
	public GameObject gameObjectPrefab;
	public int numberOfObjectsToSpawn = 10;
	public Vector3 areaSize = Vector3.zero;
	public Vector3 offset = Vector3.zero;
	public GameObject parentGameObject;


	// Use this for initialization
	void Start () 
	{
		if ( this.parentGameObject == null )
		{
			this.parentGameObject = this.gameObject;
		}

		Spawn();
	}
	
	// Update is called once per frame
	void Update () 
	{
	
	}


	public void Spawn ()
	{
		if ( this.gameObjectPrefab )
		{
			for ( int i = 0; i < this.numberOfObjectsToSpawn; i++ )
			{
				GameObject spawnedGameObject = GameObject.Instantiate ( this.gameObjectPrefab ) as GameObject;
				spawnedGameObject.transform.parent = this.parentGameObject.transform;
				spawnedGameObject.transform.localPosition = new Vector3 ( Random.Range ( 0, this.areaSize.x ) - this.areaSize.x / 2f, Random.Range ( 0, this.areaSize.y ) - this.areaSize.y / 2f, Random.Range ( 0, this.areaSize.z ) - this.areaSize.z / 2f ) + offset;
				spawnedGameObject.transform.localScale = Vector3.one;
			}
		}
	}
}
