﻿// Aaron Lanterman, June 14, 2014

using UnityEngine;
using System.Collections;

public class RotateChest : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		transform.Rotate (20*Time.deltaTime, 0, 0);
	}
}
