module hex

    implicit none

    contains

    subroutine readWord(w)
        
        character(len=11), intent(out) :: w

        do ! Get user input until valid input entered
            write(*,*) 'Enter word: '
            read(*,*) w
            if (len_trim(w) >= 5 .and. len_trim(w) <= 10) then
                exit
            end if 
        end do

        return
        
    end subroutine readWord

    subroutine word2hex(w,h,l)

        character(len=11), intent(in) :: w
        character(len=32), intent(out) :: h
        integer, intent(out) :: l

        character(len=2) :: byte
        integer :: i

        h=''

        ! Iterate through each character and convert to hex
        do i = 1, len_trim(w)
            write(byte,'(Z2)') w(i:i)
            h = trim(h) // byte
        end do
        l = len_trim(h)

        return
    end subroutine word2hex

    subroutine printhex(h,l)
    
        character(len=32), intent(out) :: h
        integer, intent(out) :: l

        ! Print hex word as string of characters
        write(*,*) 'Hexadecimal word:'
        write(*,'(a)') h
        l = len_trim(h)

        return

    end subroutine printHex

end module hex









