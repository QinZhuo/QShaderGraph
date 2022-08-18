using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using QTool;
public class CreateShaderWindow : EditorWindow
{
    public string shaderName="";
    public CreateShaderWindow()
    {
       
        titleContent = new GUIContent("ճ��������UIShader");

    }
    System.Action<string> OnOk;
    System.Action OnCancel;
    public void Init(string name,System.Action<string> OnOk, System.Action OnCancel=null)
    {
        name = name.SplitEndString("/");
        shaderName =string.IsNullOrEmpty(name)? "UIShader":name+"UI";
        this.OnOk = OnOk;
        this.OnCancel = OnCancel;
    }
    private void OnGUI()
    {
        GUILayout.Space(20);
        GUILayout.Label("shader����");
        shaderName=GUILayout.TextField(shaderName);
        GUILayout.Space(20);
        GUILayout.BeginHorizontal();
        if (GUILayout.Button("ȷ��"))
        {
            OnOk?.Invoke(shaderName);
            Close();
        }
        if (GUILayout.Button("ȡ��"))
        {
            OnCancel?.Invoke();
            Close();
        }
        GUILayout.EndHorizontal();
        GUILayout.Space(20);
    }
}
