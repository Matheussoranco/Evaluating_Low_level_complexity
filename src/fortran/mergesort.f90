module mergesort_module
contains

  recursive subroutine mergesort(arr, left, right)
    implicit none
    integer, intent(inout) :: arr(:)
    integer, intent(in)    :: left, right
    integer :: mid

    if (left >= right) return

    mid = left + (right - left) / 2
    call mergesort(arr, left, mid)
    call mergesort(arr, mid + 1, right)
    call merge(arr, left, mid, right)
  end subroutine mergesort

  subroutine merge(arr, left, mid, right)
    implicit none
    integer, intent(inout) :: arr(:)
    integer, intent(in)    :: left, mid, right
    integer :: n1, n2, i, j, k
    integer, allocatable :: L(:), R(:)

    n1 = mid - left + 1
    n2 = right - mid
    allocate(L(n1), R(n2))

    do i = 1, n1
      L(i) = arr(left + i - 1)
    end do
    do j = 1, n2
      R(j) = arr(mid + j)
    end do

    i = 1
    j = 1
    k = left
    do while (i <= n1 .and. j <= n2)
      if (L(i) <= R(j)) then
        arr(k) = L(i)
        i = i + 1
      else
        arr(k) = R(j)
        j = j + 1
      end if
      k = k + 1
    end do

    do while (i <= n1)
      arr(k) = L(i)
      i = i + 1
      k = k + 1
    end do

    do while (j <= n2)
      arr(k) = R(j)
      j = j + 1
      k = k + 1
    end do

    deallocate(L, R)
  end subroutine merge

end module mergesort_module

program test_mergesort
  use mergesort_module
  implicit none
  integer, allocatable :: arr(:)
  integer :: i, n

  n = 6
  allocate(arr(n))
  arr = (/ 5, 2, 9, 1, 5, 6 /)

  call mergesort(arr, 1, n)

  do i = 1, n
    write(*, '(I0,1X)', advance='no') arr(i)
  end do
  write(*,*)

  deallocate(arr)
end program test_mergesort
