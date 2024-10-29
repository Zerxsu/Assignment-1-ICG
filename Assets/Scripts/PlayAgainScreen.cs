using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayAgainScreen : MonoBehaviour
{
    public GameObject uiPanel; // Assign your UI Panel in the Inspector
    private bool isFrozen = false;

    private void OnTriggerEnter(Collider other)
    {
        // Check if the player entered the collider
        if (other.CompareTag("Player")) // Ensure your player has the "Player" tag
        {
            ShowUIPanel();
            FreezeGame();
        }
    }

    private void ShowUIPanel()
    {
        if (uiPanel != null)
        {
            uiPanel.SetActive(true); // Show the UI panel
        }
    }

    private void FreezeGame()
    {
        if (!isFrozen)
        {
            Time.timeScale = 0; // Freeze the game by setting time scale to 0
            isFrozen = true;
        }
    }

    private void UnfreezeGame()
    {
        if (isFrozen)
        {
            Time.timeScale = 1; // Resume the game by setting time scale back to 1
            isFrozen = false;
        }
    }

    private void Update()
    {
        // Check for unfreeze input (for example, pressing the Escape key)
        if (isFrozen && Input.GetKeyDown(KeyCode.Escape))
        {
            uiPanel.SetActive(false); // Hide the UI panel
            UnfreezeGame(); // Unfreeze the game
        }
    }
}
