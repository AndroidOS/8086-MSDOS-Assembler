TITLE "Open and read file line by line"

	IDEAL
	MODEL small
	STACK 256

	DATASEG
;----------- Equates

readChar db 1 dup (0)

filename db 'test.txt',0
line1 db 200 dup (0) 

filehandle dw ?

ErrorOpenMsg db 'File open error', 13, 10, '$'
ErrorReadMsg db 'File read error', 13, 10, '$'
ErrorCloseMsg db 'File close error', 13, 10, '$'
endOfFileMsg db 13, 10, '*** End of File ***', 13, 10, '$'

CODESEG

proc ReadText

    ; Read text into readChar and test for error state
beginRead:
	mov si,offset line1
	mov di,offset readChar
	mov dl, 10
	mov ah, 02h
	int 21h
readLoop1:
    mov ah,3fh
    mov bx, [filehandle]
    mov cx,1
    mov dx,offset readChar
    int 21h
	jc read_error ; test for error
	cmp ax, 0 ; test for end of file
	je endOfFile
	mov di,offset readChar
	mov dl, [di]
	mov [si], dl
	inc si
	cmp dl, 10
	je  beginRead ;complete
	inc si
	mov ah, 02h
	int 21h
	jmp readLoop1

read_error:
    mov dx, offset ErrorReadMsg
    mov ah, 9h
    int 21h
    ret
	
endOfFile:
    mov dx, offset endOfFileMsg
    mov ah, 9h
    int 21h
    ret
	
endp ReadText

proc OpenFile
	;open test.txt file and test for error state
	
    mov ah, 3Dh
    xor al, al
    mov dx, offset filename
    int 21h

    jc open_error
    mov [filehandle], ax
    ret

    open_error:
    mov dx, offset ErrorOpenMsg
    mov ah, 9h
    int 21h
    ret
endp OpenFile

proc CloseFile

	;close test.txt file and test for error state

	mov	ah,3eh
	mov bx, [filehandle]
	int	21h
	jc close_error
    ret
	
	close_error:
    mov dx, offset ErrorCloseMsg
    mov ah, 9h
    int 21h
    ret
	
endp CloseFile


;================================
start:
mov ax, @data
mov ds, ax
;================================

    
    call OpenFile
    call ReadText
    call CloseFile
	
    ; Wait for key press
    mov ah,1

    int 21h
    ; Back to text mode
    mov ah, 0
    mov al, 2
    int 10h
	
	;================================
exit:
    mov ax, 4c00h
    int 21h
    END start
