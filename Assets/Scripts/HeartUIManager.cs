using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class HeartUIManager : MonoBehaviour
{
    public Image[] hearts;
    public GameObject gameOverScreen;
    public GameObject player;

    private int currentLives;

    private void Start()
    {
        currentLives = hearts.Length;
        gameOverScreen.SetActive(false);
    }

    public void LoseHeart()
    {
        if (currentLives > 0)
        {
            currentLives--;

            hearts[currentLives].enabled = false;

            if (currentLives <= 0)
            {
                TriggerGameOver();
            }
        }
    }

    public int GetCurrentLives()
    {
        return currentLives;  // Returns the number of lives left
    }

    private void TriggerGameOver()
    {
        gameOverScreen.SetActive(true);

        if (player != null)
        {
            player.SetActive(false);
        }

        Cursor.lockState = CursorLockMode.None;
        Time.timeScale = 0f;
    }

    public void ResetHearts()
    {
        currentLives = hearts.Length;

        foreach (Image heart in hearts)
        {
            heart.enabled = true;

        }

        gameOverScreen.SetActive(false);
        Time.timeScale = 1f;

        // Re-enable the player GameObject
        if (player != null)
        {
            player.SetActive(true);
        }
    }
}
