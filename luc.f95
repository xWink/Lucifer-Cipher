program luc

    implicit none

    integer, dimension (0:7,0:15) :: k
    integer, dimension (0:7,0:7,0:1) :: m
    integer, dimension (0:127) :: key, message
    integer, dimension (0:31) :: inputKey, inputMessage
    integer :: decipher, i
    character(len = 8) :: formatInput = '(32z1.1)'
    character(len = 11) :: formatOutput = '(1x,32z1.1)'

    ! Get key and message from input
    write(*,*) 'Enter key'
    read(*,formatInput) (inputKey(i), i = 0, 31)
    write(*,*) 'Enter message'
    read(*,formatInput) (inputMessage(i), i = 0, 31)

    ! Expand the key and message into bits
    call expand(message, inputMessage, 32)
    call expand(key, inputKey, 32)

    k = reshape(key, (/8,16/))
    m = reshape(message, (/8,8,2/))

    ! Encipher the message and key, stored in k and m
    decipher = 0
    call lucifer(decipher, k, m)
    message = reshape(m, (/128/))
    write(*,*) 'Encrypted message'

    !Print ciphertext
    write(*,*) 'Ciphertext'
    call compress(message, inputMessage, 32)
    write(*,formatOutput) (inputMessage(i), i = 0, 31)

    ! Decipher the message and key
    decipher = 1
    call lucifer(decipher, k, m)  
    message = reshape(m, (/128/))

    ! Compress expanded key and message back to original
    call compress(message, inputMessage, 32)
    call compress(key, inputKey, 32)

    ! Print compressed version of expanded key/message (originals)
    write(*,*) 'Decrypted key'
    write(*,formatOutput) (inputKey(i), i = 0, 31)
    write(*,*) 'Decrypted message'
    write(*,formatOutput) (inputMessage(i), i = 0, 31)

end program luc

subroutine lucifer(d,k,m)

    implicit none

    integer, intent(in) :: d
    integer, dimension(0:7,0:7,0:1), intent(out) :: m
    integer, dimension(0:7,0:15), intent(in) :: k
    
    integer, dimension(0:7) :: o, tr, pr
    integer, dimension(0:7, 0:7) :: sw
    integer, dimension(0:15) :: s0, s1
    integer :: h0, h1, kc, ks, l, h, ii, kk, v, jj, jjj

    !diffusion pattern
    data o/7,6,2,1,5,0,3,4/

    !inverse of fixed permutation
    data pr/2,5,4,0,3,1,7,6/

    !S-box permutations
    data s0/12,15,7,10,14,13,11,0,2,6,3,1,9,4,5,8/
    data s1/7,2,14,9,3,11,0,4,12,13,1,10,6,15,8,5/

    h0 = 0
    h1 = 1
    kc = 0

    if (d .eq. 1) then
        kc = 8
    end if

    do ii = 1,16,1

        if (d.eq.1) then
            kc = mod(kc+1,16)
        end if

        ks = kc

        do jj = 0,7,1
            l = 0
            h = 0

            do kk = 0,3,1
                l = l*2+m(7-kk,jj,h1)
            end do

            do kk = 4,7,1
                h = h*2+m(7-kk,jj,h1)
            end do

            v = (s0(l)+16*s1(h))*(1-k(jj,ks))+(s0(h)+16*s1(l))*k(jj,ks)

            do kk = 0,7,1
                tr(kk) = mod(v,2)
                v = v/2
            end do

            do kk = 0,7,1
                m(kk,mod(o(kk)+jj,8),h0) = mod(k(pr(kk),kc)+tr(pr(kk))&
                +m(kk,mod(o(kk)+jj,8),h0),2)
            end do

            if (jj .lt. 7 .or. d .eq. 1) then
                kc = mod(kc+1,16)
            end if

        end do

        jjj = h0
        h0 = h1
        h1 = jjj

    end do

    do jj = 0,7,1
        do kk = 0,7,1
            sw(kk,jj) = m(kk,jj,0)
            m(kk,jj,0) = m(kk,jj,1)
            m(kk,jj,1) = sw(kk,jj)
        end do
    end do
return 
end subroutine lucifer

! Takes in an array of bytes and expands them into bits.
subroutine expand(bitArray, byteArray, length)

    implicit none

    integer, intent(in) :: length
    integer, dimension (0:127), intent(out) :: bitArray
    integer, dimension (0:length-1), intent(in) :: byteArray
    integer :: i, j, byteVal

    do i = 0, length - 1
        byteVal = byteArray(i)
        do j = 0, 3
            bitArray((3 - j) + i * 4) = mod(byteVal, 2)
            byteVal = byteVal / 2
        end do
    end do
    return
end

! Takes an array of bits and compresses them into bytes.
subroutine compress(bitArray, byteArray, length)

    implicit none

    integer :: i, j
    integer, intent(in) :: length
    integer, dimension (0:127), intent(in) :: bitArray
    integer, dimension (0:length-1), intent(out) :: byteArray

    do i = 0, length - 1
        byteArray(i) = 0
        do j = 0, 3
            byteArray(i) = byteArray(i) * 2 + mod(bitArray(j + i * 4), 2)
        end do
    end do
    return
end
