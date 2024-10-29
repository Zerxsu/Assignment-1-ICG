using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MaterialSwitcher : MonoBehaviour
{
    public Material[] materials; // Assign your materials in the inspector
    private Renderer objectRenderer;

    void Start()
    {
        objectRenderer = GetComponent<Renderer>();

        // Ensure only the first material is active initially
        if (materials.Length > 0)
        {
            objectRenderer.material = materials[0];
        }
    }

    void Update()
    {
        // Check for key presses and switch materials
        if (Input.GetKeyDown(KeyCode.Alpha1) && materials.Length > 0)
        {
            objectRenderer.material = materials[0];
        }
        else if (Input.GetKeyDown(KeyCode.Alpha2) && materials.Length > 1)
        {
            objectRenderer.material = materials[1];
        }
        else if (Input.GetKeyDown(KeyCode.Alpha3) && materials.Length > 2)
        {
            objectRenderer.material = materials[2];
        }
    }
}
