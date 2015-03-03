// Aaron Lanterman, June 18, 2014

using UnityEngine;
using System.Collections;

public class RotateTestObject : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		transform.Rotate (0, 20*Time.deltaTime, 0);
	}
}
