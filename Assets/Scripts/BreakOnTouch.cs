using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class BreakOnTouch : MonoBehaviour
{
    public float respawnDelay = 3f; // Delay before respawning (optional)
    private HeartUIManager heartUIManager;
    public GameObject player;


    private void Start()
    {
        heartUIManager = FindObjectOfType<HeartUIManager>();
    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            StartCoroutine(RespawnPlayer(other.gameObject));
        }

    }

    System.Collections.IEnumerator RespawnPlayer(GameObject player)
    {
        // Disable player movement during respawn delay
        player.GetComponent<CharacterController>().enabled = false;

        yield return new WaitForSeconds(respawnDelay);

        // Find the CheckpointManager and get the current respawn point
        CheckpointManager checkpointManager = FindObjectOfType<CheckpointManager>();
        Transform respawnPoint = checkpointManager.GetCurrentRespawnPoint();

        // Move the player to the respawn point
        player.transform.position = respawnPoint.position;
        player.transform.rotation = respawnPoint.rotation;

        // Re-enable player movement after respawn
        player.GetComponent<CharacterController>().enabled = true;

        heartUIManager.LoseHeart();
    }
}
