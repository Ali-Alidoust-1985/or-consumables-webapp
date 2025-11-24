<!doctype html>
<html lang="fa" dir="rtl">
<head>
    <meta charset="utf-8">
    <title>ثبت اقلام اتاق عمل</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body{font-family: sans-serif; margin:16px}
        video, canvas{width:100%; max-width:480px; border-radius:12px}
        .pill{display:inline-block; padding:6px 10px; border-radius:16px; background:#eee; margin:4px 0}
    </style>
</head>
<body>
<h2>اسکن مچ‌بند بیمار</h2>
<div id="patientBox" class="pill">بیمار انتخاب نشده</div>
<video id="cam" autoplay playsinline></video>
<canvas id="frame" hidden></canvas>

<div style="margin:12px 0">
    <button id="btnPatient">اسکن مچ‌بند</button>
    <button id="btnItem">اسکن کالای مصرفی</button>
</div>

<ul id="log"></ul>

<script src="https://unpkg.com/jsqr/dist/jsQR.js"></script>
<!-- اگر می‌خواهی بارکد 1D هم بخوانی، QuaggaJS یا ZXing را هم اضافه کن -->

<script>
    const video = document.getElementById('cam');
    const canvas = document.getElementById('frame');
    const ctx = canvas.getContext('2d');
    const log = (m)=>document.getElementById('log').insertAdjacentHTML('afterbegin', `<li>${m}</li>`);

    let mode = 'patient'; // patient | item
    let stream;

    async function startCam(){
        if(stream) return;
        stream = await navigator.mediaDevices.getUserMedia({video:{facingMode:'environment'}});
        video.srcObject = stream;
        await video.play();
        canvas.width = video.videoWidth;
        canvas.height = video.videoHeight;
        requestAnimationFrame(tick);
    }

    async function postJSON(url, data){
        const r = await fetch(url,{method:'POST',headers:{'Content-Type':'application/json'}, body:JSON.stringify(data)});
        if(!r.ok) throw new Error(await r.text());
        return r.json();
    }

    function tick(){
        if(video.readyState === video.HAVE_ENOUGH_DATA){
            ctx.drawImage(video,0,0,canvas.width,canvas.height);
            const img = ctx.getImageData(0,0,canvas.width,canvas.height);
            const qr = jsQR(img.data, img.width, img.height);
            if(qr?.data){
                const code = qr.data.trim();
                if(mode==='patient'){
                    postJSON('/api/scans/patient',{code}).then(p=>{
                        document.getElementById('patientBox').textContent = `بیمار: ${p.fullName} | ENC: ${p.encounterNo}`;
                        log(`Patient OK: ${code}`);
                    }).catch(e=>log('Patient ERR: '+e.message));
                }else{
                    postJSON('/api/scans/item',{code}).then(x=>{
                        log(`Item OK: ${x.consumable.name} × ${x.qty}`);
                    }).catch(e=>log('Item ERR: '+e.message));
                }
                // فاصله برای جلوگیری از ثبت پشت‌سرهم
                setTimeout(()=>{}, 800);
            }
        }
        requestAnimationFrame(tick);
    }

    document.getElementById('btnPatient').onclick = ()=>{ mode='patient'; startCam(); };
    document.getElementById('btnItem').onclick    = ()=>{ mode='item'; startCam(); };
</script>
</body>
</html>
