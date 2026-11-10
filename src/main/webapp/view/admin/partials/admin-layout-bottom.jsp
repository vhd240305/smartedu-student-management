<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
</div>
</main>
</div>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js">
</script>

<script>
(function () {
    const wrapper = document.getElementById('classDropdownWrapper');
    const trigger = document.getElementById('classDropdownTrigger');
    const panel   = document.getElementById('classDropdownPanel');
    const arrow   = document.getElementById('classDropdownArrow');
    const lbl     = document.getElementById('classDropdownLabel');
    const search  = document.getElementById('classSearch');
    const optList = document.getElementById('classOptionList');

    let open = false;

    function openDD() {
        open = true;
        panel.style.display = 'block';
        arrow.style.transform = 'rotate(180deg)';
        search.focus();
    }

    function closeDD() {
        open = false;
        panel.style.display = 'none';
        arrow.style.transform = '';
        document.querySelectorAll('.class-option').forEach(opt => {
            opt.classList.remove('d-none');
        });
        search.value = '';
    }

    trigger.addEventListener('click', () => open ? closeDD() : openDD());

    document.addEventListener('click', e => {
        if (!wrapper.contains(e.target)) closeDD();
    });

    search.onkeyup = function () {
        const q = this.value.toLowerCase().trim().normalize('NFC');
        document.querySelectorAll('.class-option').forEach(opt => {
            const name = opt.getAttribute('data-name').toLowerCase().normalize('NFC');
            if (name.includes(q)) {
                opt.classList.remove('d-none');
            } else {
                opt.classList.add('d-none');
            }
        });
    };

    optList.addEventListener('change', () => {
        const count = document.querySelectorAll('[name="classroomIds"]:checked').length;
        lbl.textContent = count ? `Đã chọn ${count} lớp` : '-- Chọn lớp học --';
        lbl.className = count ? 'text-dark' : 'text-muted';
    });
})();
</script>

<script>
(function () {
    const wrapper = document.getElementById('classDropdownWrapper');
    const trigger = document.getElementById('classDropdownTrigger');
    const panel   = document.getElementById('classDropdownPanel');
    const arrow   = document.getElementById('classDropdownArrow');
    const lbl     = document.getElementById('classDropdownLabel');
    const search  = document.getElementById('classSearch');
    const optList = document.getElementById('classOptionList');

    let open = false;

    function openDD() {
        open = true;
        panel.style.display = 'block';
        arrow.style.transform = 'rotate(180deg)';
        search.focus();
    }

    function closeDD() {
        open = false;
        panel.style.display = 'none';
        arrow.style.transform = '';
        document.querySelectorAll('.class-option').forEach(opt => {
            opt.classList.remove('d-none');
        });
        search.value = '';
    }

    trigger.addEventListener('click', () => open ? closeDD() : openDD());

    document.addEventListener('click', e => {
        if (!wrapper.contains(e.target)) closeDD();
    });

    search.onkeyup = function () {
        const q = this.value.toLowerCase().trim().normalize('NFC');
        document.querySelectorAll('.class-option').forEach(opt => {
            const name = opt.getAttribute('data-name').toLowerCase().normalize('NFC');
            if (name.includes(q)) {
                opt.classList.remove('d-none');
            } else {
                opt.classList.add('d-none');
            }
        });
    };

    optList.addEventListener('change', () => {
        const count = document.querySelectorAll('[name="classroomIds"]:checked').length;
        lbl.textContent = count ? `Đã chọn ${count} lớp` : '-- Chọn lớp học --';
        lbl.className = count ? 'text-dark' : 'text-muted';
    });
})();
</script>

<script>
(function () {
    const wrapper = document.getElementById('teacherDropdownWrapper');
    const trigger = document.getElementById('teacherDropdownTrigger');
    const panel   = document.getElementById('teacherDropdownPanel');
    const arrow   = document.getElementById('teacherDropdownArrow');
    const lbl     = document.getElementById('teacherDropdownLabel');
    const search  = document.getElementById('teacherSearch');
    const hiddenInput = document.getElementById('selectedTeacherId');

    let open = false;

    function openDD() {
        open = true;
        panel.style.display = 'block';
        arrow.style.transform = 'rotate(180deg)';
        search.focus();
    }

    function closeDD() {
        open = false;
        panel.style.display = 'none';
        arrow.style.transform = '';
        document.querySelectorAll('.teacher-option').forEach(opt => {
            opt.classList.remove('d-none');
        });
        search.value = '';
    }

    trigger.addEventListener('click', () => open ? closeDD() : openDD());

    document.addEventListener('click', e => {
        if (!wrapper.contains(e.target)) closeDD();
    });

    search.onkeyup = function () {
        const q = this.value.toLowerCase().trim().normalize('NFC');
        document.querySelectorAll('.teacher-option').forEach(opt => {
            const name = opt.getAttribute('data-name').toLowerCase().normalize('NFC');
            if (name.includes(q)) {
                opt.classList.remove('d-none');
            } else {
                opt.classList.add('d-none');
            }
        });
    };

    // Chọn giảng viên khi click vào option
    document.querySelectorAll('.teacher-option').forEach(opt => {
        opt.addEventListener('click', () => {
            const id   = opt.getAttribute('data-id');
            const name = opt.getAttribute('data-name');

            // Bỏ highlight tất cả
            document.querySelectorAll('.teacher-option').forEach(o => {
                o.style.background = '';
                o.style.fontWeight = '';
            });

            if (id === '') {
                // Bỏ chọn
                hiddenInput.value = '';
                lbl.textContent = '-- Chọn giảng viên --';
                lbl.className = 'text-muted';
            } else {
                // Chọn giảng viên
                hiddenInput.value = id;
                lbl.textContent = name;
                lbl.className = 'text-dark';
                opt.style.background = '#e8f0fe';
                opt.style.fontWeight = '500';
            }

            closeDD();
        });
    });
})();

</script>

<script>
(function () {
    const wrapper    = document.getElementById('teacherDropdownWrapper');
    const trigger    = document.getElementById('teacherDropdownTrigger');
    const panel      = document.getElementById('teacherDropdownPanel');
    const arrow      = document.getElementById('teacherDropdownArrow');
    const lbl        = document.getElementById('teacherDropdownLabel');
    const search     = document.getElementById('teacherSearch');
    const hiddenInput = document.getElementById('selectedTeacherId');
    const error      = document.getElementById('teacherError');

    let open = false;

    function openDD() {
        open = true;
        panel.style.display = 'block';
        arrow.style.transform = 'rotate(180deg)';
        search.focus();
    }

    function closeDD() {
        open = false;
        panel.style.display = 'none';
        arrow.style.transform = '';
        document.querySelectorAll('.teacher-option').forEach(opt => {
            opt.classList.remove('d-none');
        });
        search.value = '';
    }

    trigger.addEventListener('click', () => open ? closeDD() : openDD());

    document.addEventListener('click', e => {
        if (!wrapper.contains(e.target)) closeDD();
    });

    search.onkeyup = function () {
        const q = this.value.toLowerCase().trim().normalize('NFC');
        document.querySelectorAll('.teacher-option').forEach(opt => {
            const name = opt.getAttribute('data-name').toLowerCase().normalize('NFC');
            if (name.includes(q)) {
                opt.classList.remove('d-none');
            } else {
                opt.classList.add('d-none');
            }
        });
    };

    document.querySelectorAll('.teacher-option').forEach(opt => {
        opt.addEventListener('click', () => {
            const id   = opt.getAttribute('data-id');
            const name = opt.getAttribute('data-name');

            document.querySelectorAll('.teacher-option').forEach(o => {
                o.style.background = '';
                o.style.fontWeight = '';
            });

            hiddenInput.value = id;
            lbl.textContent = name;
            lbl.className = 'text-dark';
            opt.style.background = '#e8f0fe';
            opt.style.fontWeight = '500';
            error.style.display = 'none';

            closeDD();
        });
    });
})();
</script>


</body>
</html>
