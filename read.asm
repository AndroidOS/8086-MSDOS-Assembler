TITLE "Open and read file Example"

	IDEAL
	MODEL small
	STACK 256

	DATASEG
;----------- Equates

textBuffer db 20000 dup (0)

filename db 'test.txt',0

filehandle dw ?

ErrorOpenMsg db 'File open error', 13, 10, '$'
ErrorReadMsg db 'File read error', 13, 10, '$'
ErrorCloseMsg db 'File close error', 13, 10, '$'

CODESEG

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

proc ReadText

    ; Read text into textBuffer and test for error state

    mov ah,3fh
    mov bx, [filehandle]
    mov cx,15000
    mov dx,offset textBuffer
    int 21h
	jc read_error
    ret
	
	read_error:
    mov dx, offset ErrorReadMsg
    mov ah, 9h
    int 21h
    ret
	
endp ReadText

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

proc DisplayText
	mov di,offset textBuffer
	loopDisplay:
		mov dl, [di]
		mov ah, 2
		int 21h
		inc di
		cmp dl, 0
		jne loopDisplay
	ret
endp DisplayText


;================================
start:
mov ax, @data
mov ds, ax
;================================

    
    call OpenFile
    call ReadText
	call DisplayText
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

   
		
	

	
	

	
