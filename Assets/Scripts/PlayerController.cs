using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    public CharacterController controller;  // Reference to the CharacterController component
    public Transform cameraTransform;  // Reference to the Camera transform
    public float speed = 6f;  // Movement speed
    public float turnSmoothTime = 0.1f;  // Time for smooth turning
    private float turnSmoothVelocity;  // Velocity used for smooth turning

    Animator animator;
    bool isMovementPressed;
    bool isRunningPressed;

    public float gravity = -9.8f;
    public float jumpHeight = 2.0f;
    private Vector3 velocity;
    private bool isGrounded;

    void Start()
    {
        Cursor.lockState = CursorLockMode.Locked;
    }

    void Awake()
    {
        animator = GetComponent<Animator>();
        controller = GetComponent<CharacterController>();
    }

    void Update()
    {

        isGrounded = controller.isGrounded;

        if (isGrounded && velocity.y < 0) 
        {
            velocity.y = -2f;
        }


        // Get input from the horizontal and vertical axes (WASD or Arrow keys)
        float horizontal = Input.GetAxisRaw("Horizontal");
        float vertical = Input.GetAxisRaw("Vertical");
        Vector3 direction = new Vector3(horizontal, 0f, vertical).normalized;

        if (Input.GetKey(KeyCode.LeftAlt))
        {
            Cursor.lockState = CursorLockMode.None;
        }

        else
        {
            Cursor.lockState = CursorLockMode.Locked;
        }

        if (Input.GetKeyDown(KeyCode.Space) && isGrounded)
        {
            velocity.y = Mathf.Sqrt(jumpHeight * -2f * gravity);
        }


        if (direction.magnitude >= 0.1f)
        {
            // Get the target angle based on the camera's facing direction
            float targetAngle = Mathf.Atan2(direction.x, direction.z) * Mathf.Rad2Deg + cameraTransform.eulerAngles.y;
            float angle = Mathf.SmoothDampAngle(transform.eulerAngles.y, targetAngle, ref turnSmoothVelocity, turnSmoothTime);

            // Rotate the player to face the movement direction
            transform.rotation = Quaternion.Euler(0f, angle, 0f);

            // Move the player in the direction the camera is facing
            Vector3 moveDirection = Quaternion.Euler(0f, targetAngle, 0f) * Vector3.forward;
            controller.Move(moveDirection.normalized * speed * Time.deltaTime);

            isMovementPressed = true;

            if (isMovementPressed && (Input.GetKey(KeyCode.LeftShift)))
            {
                speed = 6f;
                isRunningPressed = true;
            }
            else
            {
                speed = 2f;
                isRunningPressed = false;
            }
        }

        else
        {
            isMovementPressed = false;
        }

        velocity.y += gravity * Time.deltaTime;
        controller.Move(velocity * Time.deltaTime);

        handleAnimation();
    }

    void handleAnimation()
    {
        // get parameter values from animator
        bool isWalking = animator.GetBool("isWalking");
        bool isRunning = animator.GetBool("isRunning");

        // start walking if movement pressed is true and not already walking
        if (isMovementPressed && !isWalking)
        {
            animator.SetBool("isWalking", true);
        }
        else if (!isMovementPressed && isWalking)
        {
            animator.SetBool("isWalking", false);
        }

        else if (isMovementPressed && isRunningPressed)
        {
            animator.SetBool("isRunning", true);
        }

        if (!isMovementPressed || !isRunningPressed)
        {
            animator.SetBool("isRunning", false);
        }

    }

}

