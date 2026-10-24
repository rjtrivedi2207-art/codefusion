// CodeFusion — shared client-side behavior (no framework, plain JS)

document.addEventListener('DOMContentLoaded', function () {

    var toggle = document.getElementById('cfNavToggle');
    var links = document.getElementById('cfNavLinks');
    if (toggle && links) {
        toggle.addEventListener('click', function () {
            links.classList.toggle('open');
        });
    }

    var terminal = document.getElementById('heroTerminalBody');
    if (terminal) {
        var lines = [
            { text: '> dotnet run --project CodeFusion', cls: '' },
            { text: 'Building learning roadmap...', cls: 'cm-com' },
            { text: 'Loaded 12 modules, 40+ lessons', cls: 'cm-str' },
            { text: 'Practice Lab: Controls, DropDowns, Validation, CRUD ready', cls: 'cm-str' },
            { text: 'Debug Lab: 3 challenge types armed', cls: 'cm-str' },
            { text: '> student.StartLearning();', cls: '' }
        ];
        typeLines(terminal, lines);
    }

    document.querySelectorAll('[data-hint-trigger]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var targetId = btn.getAttribute('data-hint-trigger');
            var el = document.getElementById(targetId);
            if (el) {
                el.style.display = 'block';
                btn.setAttribute('disabled', 'disabled');
            }
        });
    });
});

function typeLines(container, lines) {
    container.innerHTML = '';
    var lineIndex = 0;

    function nextLine() {
        if (lineIndex >= lines.length) {
            var caret = document.createElement('span');
            caret.className = 'caret';
            container.appendChild(caret);
            return;
        }
        var lineEl = document.createElement('div');
        lineEl.className = lines[lineIndex].cls;
        lineEl.style.marginBottom = '6px';
        container.appendChild(lineEl);

        var text = lines[lineIndex].text;
        var charIndex = 0;

        var interval = setInterval(function () {
            lineEl.textContent = text.substring(0, charIndex + 1);
            charIndex++;
            if (charIndex >= text.length) {
                clearInterval(interval);
                lineIndex++;
                setTimeout(nextLine, 220);
            }
        }, 16);
    }
    nextLine();
}
