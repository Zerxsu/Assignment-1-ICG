using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class CheckpointManager : MonoBehaviour
{
    public Transform defaultSpawnPoint;  // Set the default spawn point in the Inspector
    private Transform currentRespawnPoint;

    private void Start()
    {
        // Initially, the respawn point is set to the default spawn point
        currentRespawnPoint = defaultSpawnPoint;
    }

    public void UpdateCheckpoint(Transform newCheckpoint)
    {
        // Update the current respawn point to the latest checkpoint
        currentRespawnPoint = newCheckpoint;
    }

    public Transform GetCurrentRespawnPoint()
    {
        // Returns the current respawn point
        return currentRespawnPoint;
    }

    public void ResetSpawnPoint()
    {
        SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
        Debug.Log("Game restarted, scene reloaded.");
    }
}
