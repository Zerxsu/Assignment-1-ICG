using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Checkpoint : MonoBehaviour
{
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))  // Ensure only the player can trigger the checkpoint
        {
            // Find the CheckpointManager in the scene and update the checkpoint
            CheckpointManager checkpointManager = FindObjectOfType<CheckpointManager>();
            checkpointManager.UpdateCheckpoint(transform);

            // Optionally, you can add visual or audio feedback that the checkpoint is activated
            Debug.Log("Checkpoint reached!");
        }
    }
}
