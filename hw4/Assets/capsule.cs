using UnityEngine;
using System.Collections;

public class capsule : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {

		float speed = .2f * Mathf.Sin (Time.time) * Time.deltaTime;

		transform.Translate (new Vector3 (0, 0, speed), Space.World);

		transform.Rotate (0, 10f * Time.deltaTime, 10f * Time.deltaTime);
		
	}
}
