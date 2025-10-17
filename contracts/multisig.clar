;; Import the SIP-010 fungible token trait
(use-trait ft-trait 'SP3FBR2AGK5H9QBDH3EEN6DF8EK8JY7RX8QJ5SVTE.sip-010-trait-ft-standard.sip-010-trait)

;; Constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant MAX_SIGNERS u100)
(define-constant MIN_SIGNATURES_REQUIRED u1)

;; Errors
(define-constant ERR_OWNER_ONLY (err u500))
(define-constant ERR_ALREADY_INITIALIZED (err u501))
(define-constant ERR_TOO_MANY_SIGNERS (err u502))
(define-constant ERR_TOO_FEW_SIGNATURES_REQUIRED (err u503))
(define-constant ERR_NOT_A_SIGNER (err u504))
(define-constant ERR_INVALID_TX_TYPE (err u505))
(define-constant ERR_NO_TOKEN_CONTRACT_FOR_SIP010_TRANSFER (err u506))
(define-constant ERR_INVALID_TXN_ID (err u507))
(define-constant ERR_INVALID_AMOUNT (err u508))
(define-constant ERR_MIN_THRESHOLD_NOT_MET (err u509))
(define-constant ERR_INVALID_TOKEN_CONTRACT (err u510))
(define-constant ERR_NOT_INITIALIZED (err u511))
(define-constant ERR_UNEXPECTED (err u999))

;; Storage Vars
(define-data-var initialized bool false)
(define-data-var signers (list 100 principal) (list))
(define-data-var threshold uint u0)

(define-data-var txn-id uint u0)
(define-map transactions
    { id: uint }
    {
        type: uint,
        amount: uint,
        recipient: principal,
        token: (optional principal),
        executed: bool,
    }
)
(define-map txn-signers
    {
        id: uint,
        member: principal,
    }
    { has-signed: bool }
)

;; Public Functions
;; Initialize the contract with the given signers and threshold
;; Can only be called once by the contract owner
(define-public (initialize
        (new-signers (list 100 principal))
        (min-threshold uint)
    )
    (begin
        (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_OWNER_ONLY)
        (asserts! (is-eq (var-get initialized) false) ERR_ALREADY_INITIALIZED)
        (asserts! (<= (len new-signers) MAX_SIGNERS) ERR_TOO_MANY_SIGNERS)
        (asserts! (>= min-threshold MIN_SIGNATURES_REQUIRED)
            ERR_MIN_THRESHOLD_NOT_MET
        )
        (var-set signers new-signers)
        (var-set threshold min-threshold)
        (var-set initialized true)
        (ok true)
    )
)