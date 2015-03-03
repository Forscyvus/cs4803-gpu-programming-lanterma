// Aaron Lanterman, June 14, 2014

using UnityEngine;
using System.Collections;

public class MoveLight2 : MonoBehaviour {

	Vector3 startingPosition;

	// Use this for initialization
	void Start () {
		startingPosition = transform.position;
	}
	
	// Update is called once per frame
	void Update () {
		transform.position = startingPosition + (5f*new Vector3 (Mathf.Sin(5f * Time.time), 0f, 0f));
	}
}
