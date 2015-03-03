// Aaron Lanterman, July 18, 2014
// Cobbled together from numerous sources

using UnityEngine;
using System.Collections;

// based on Texture2D.ReadPixels Unity script reference

public class ReplacementShaderCapture : MonoBehaviour {

	public Shader replacementShader;
	public Texture2D capturedTex;
	public Material postMat; 

	// Using a Vector4 because it seems like you can't pass
	// just a Vector2 into a material
	Vector4 cameraData;

	void Start() { 
		capturedTex = new Texture2D(Screen.width,Screen.height,TextureFormat.ARGB32,false);
	}

	void OnPreRender() {
		cameraData.y = Mathf.Tan(Mathf.Deg2Rad * camera.fieldOfView / 2);   
		cameraData.x = cameraData.y * camera.aspect;
		cameraData.z = camera.farClipPlane - camera.nearClipPlane;
		cameraData.w = camera.nearClipPlane;
		Shader.SetGlobalVector("_CameraData",cameraData);
		camera.CopyFrom(Camera.main);
		camera.SetReplacementShader(replacementShader,"");
	}

	void Update() {
	}

	void OnPostRender() {
		capturedTex.ReadPixels(new Rect(0,0,Screen.width,Screen.height),0,0,false);
		capturedTex.Apply();
	}
}