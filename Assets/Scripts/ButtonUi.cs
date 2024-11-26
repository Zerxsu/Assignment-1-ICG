using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class ButtonUi : MonoBehaviour, IPointerEnterHandler, IPointerExitHandler
{
    [Header("Scaling Settings")]
    [Tooltip("The component to scale (e.g., RectTransform).")]
    public Transform targetToScale;

    [Tooltip("The scale multiplier applied when the cursor is over the image.")]
    [Range(0.1f, 1f)]
    public float scaleAmount = 0.9f;

    [Tooltip("The speed of the scaling animation.")]
    public float scaleSpeed = 5f;

    private Vector3 originalScale;
    private Vector3 targetScale;
    private bool isPointerOver;

    private void OnEnable()
    {
        // Ensure the target scale is reset when the object is re-enabled
        ResetScale();
        SceneManager.sceneLoaded += OnSceneLoaded;
    }

    private void OnDisable()
    {
        // Stop listening to scene load events when the object is disabled
        SceneManager.sceneLoaded -= OnSceneLoaded;
    }

    private void OnSceneLoaded(Scene scene, LoadSceneMode mode)
    {
        // Reset the scaling values after a scene load
        ResetScale();
    }

    private void Start()
    {
        // Enable alpha hit testing for the image
        this.GetComponent<Image>().alphaHitTestMinimumThreshold = 0.1f;

        // Ensure a target is assigned, fallback to self if not
        if (targetToScale == null)
            targetToScale = transform;

        // Store the original scale of the target
        originalScale = targetToScale.localScale;
        targetScale = originalScale;
    }

    private void Update()
    {
        // Smoothly interpolate the scale of the target
        targetToScale.localScale = Vector3.Lerp(targetToScale.localScale, targetScale, Time.unscaledDeltaTime * scaleSpeed);
    }

    public void OnPointerEnter(PointerEventData eventData)
    {
        // Set the target scale to the smaller size
         Debug.Log("Pointer Entered");
        targetScale = originalScale * scaleAmount;
        isPointerOver = true;
    }

    public void OnPointerExit(PointerEventData eventData)
    {
        // Set the target scale back to the original size
        Debug.Log("Pointer Exited");
        targetScale = originalScale;
        isPointerOver = false;
    }

    // Reset scale to original values
    private void ResetScale()
    {
        if (targetToScale != null)
        {
            originalScale = targetToScale.localScale;
            targetScale = originalScale;
        }
    }
}
