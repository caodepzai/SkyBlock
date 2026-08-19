 
goodsIdList={}
goodsIdList[251]={[0]=131014,[1] = 131081,[2] = 131082,[3] = 131083,[4] = 131084,[5] = 131085,[6] = 131091,[7] = 131092,[8] = 131093,[9] = 131094,[10] = 131095,[11] = 131101,[12] = 131102,[13] = 131103,[14] = 131104,[15] = 131105} --bê tông
goodsIdList[95]={[0]=131012,[1]=131021,[2]=131022,[3]=131023,[4]=131024,[5]=131025,[6]=131031,[7]=131032,[8]=131033,[9]=131034,[10]=131035,[11]=131041,[12]=131042,[13]=131043,[14]=131044,[15]=131045} --thủy tinh
goodsIdList[159]={[0]=131015,[1]=131111,[2]=131112,[3]=131113,[4]=131114,[5]=131115,[6]=131121,[7]=131122,[8]=131123,[9]=131124,[10]=131125,[11]=131131,[12]=131132,[13]=131133,[14]=131134,[15]=131135}-- gạch gốm
goodsIdList[35]={[0]=131013,[1]=131051,[2]=131052,[3]=131053,[4]=131054,[5]=131055,[6]=131061,[7]=131062,[8]=131063,[9]=131064,[10]=131065,[11]=131071,[12]=131072,[13]=131073,[14]=131074,[15]=131075}--len
goodsIdList[12]={[0]=111033}--cát
goodsIdList[170]={[0]=111051}--rơm
goodsIdList[4]={[0]=111023}--đá
goodsIdList[2419]={[0]=111113}--fale biển 
goodsIdList[19]={[0]=111122}--bọt biển 
goodsIdList[263]={[0]=221021}--than
goodsIdList[79]={[0]=111041}--băng
goodsIdList[3]={[0]=111011}--đất
goodsIdList[2]={[0]=111012}--đất cỏ
goodsIdList[18]={[0]=111022}--lá sồi
goodsIdList[17]={[0]=111021}--gỗ sồi
goodsIdList[20]={[0]=131011}--thủy trong suốt
goodsIdList[297]={[0]=221011}--banh mi

goodsIdList[264]={[0]=221024}--kim cuong
goodsIdList[265]={[0]=221022}--sắt
goodsIdList[266]={[0]=221023}--vangf
goodsIdList[405]={[0]=221032}--gach dia nguc 
craftList={}
craftList[112]={405,206}---gạch địa ngục
craftList[41]={266,231}---khối vàng
craftList[42]={265,232} --khối sắt
craftList[57]={264,230} --khối kim cương

function KaoDaODayHeheboiz() return PlayerManager and PlayerManager.getClientPlayer and PlayerManager:getClientPlayer() end

function CHETAO(id,SoLuong)
    KaoDaODayHeheboiz():sendPacket({
        pid = "tryUseWorkbench",----craft 
        id = craftList[id][2],
        multiple = SoLuong
    })
end

function MUA(id,SoLuong,meta)
    KaoDaODayHeheboiz():sendPacket({
        pid = "tryBuyGoods",-----buy shop
        goodsId=goodsIdList[id][meta],
        count=SoLuong
    })
end

function CHETAO(id,SoLuong)
    KaoDaODayHeheboiz():sendPacket({
        pid = "tryUseWorkbench",----craft 
        id = craftList[id][2],
        multiple = SoLuong
    })
end

function checkItem(id, soLuongCan, meta)
    meta = meta or -1
    soLuongCan = soLuongCan or 1
    local inv = KaoDaODayHeheboiz():getPlayerInventory()
    if not inv then return false, soLuongCan end
    local have = inv:getItemCount(id, meta) or 0
    local missing = soLuongCan - have
    if missing <= 0 then
        return true,0
    else
        return false, missing
    end
end

function checkNV()
    local g = KaoDaODayHeheboiz().task:getTaskGroup(Define.TaskGroup.TaskChain)
    if not g or not g.tasks or not g.tasks[1] then return nil end
    local task = g.tasks[1]
    local cfg = task:cfg()
    if not cfg or cfg.type ~= Define.TaskType.SubmitItem then return nil end
    local idVP = tonumber(cfg.condition[1]) or 0
    local meta = tonumber(cfg.condition[2]) or 0
    local need = tonumber(cfg.value) or 1
    local idTask = tonumber(cfg.id) or 1
    return {itemNV = idVP,meta = meta,can = need,id=idTask}
end

ruongVuaLay = nil
function LayTuRuong(id, meta)
    meta = meta or -1
    ruongVuaLay = nil
    local inv = KaoDaODayHeheboiz():getPlayerInventory()
    local bp = inv and inv.backpack and inv.backpack.key or "backpack"
    local util, mgr = T(Global, "ItemContainerUtil"), T(Global, "ItemContainerMgr")
    if not util or not mgr then return false end
    for key, cont in pairs(mgr:getAllContainers()) do
        if key:find("chest") and not key:find("backpack") and cont.slots then
            for i, slot in pairs(cont.slots) do
                if slot and slot.itemId == id and slot.count > 0 and (meta == -1 or meta == 0 or slot.meta == meta) then
                    util:tryTransferContainerSlot(key, bp, i)
                    ruongVuaLay = key
                    return true
                end
            end
        end
    end
    return false
end

function TraVaoRuong(id, meta)
    meta = meta or -1
    if not ruongVuaLay then return false end
    local inv = KaoDaODayHeheboiz():getPlayerInventory()
    if not inv then return false end
    local util = T(Global, "ItemContainerUtil")
    if not util then return false end
    local ok = false
    for _, cont in ipairs({inv.backpack, inv.hotbar}) do
        if cont and cont.slots then
            for i, slot in pairs(cont.slots) do
                if slot and slot.itemId == id and slot.count > 0 and (meta == -1 or meta == 0 or slot.meta == meta) then
                    util:tryTransferContainerSlot(cont.key,ruongVuaLay, i)
                    ok = true
                end
            end
        end
    end
    if ok then ruongVuaLay = nil end
    return ok
end

function doneeeeeeeeeeeeee()
    KaoDaODayHeheboiz():sendPacket({pid="tryDoSubmitItemTask",index=1,group="task_chain"})
    KaoDaODayHeheboiz():sendPacket({pid = "tryTaskChainGrandPrice"})
    if not DaAnBangThongBaoKetQua then AnReward() end
    TraVaoRuong(NhiemVu.itemNV, NhiemVu.meta)
end

function AnReward()
    local names = {"RewardResult","RewardResult-Confirm","RewardResult-Content","RewardResult-Title"}
    local count = 0
    for _, name in ipairs(names) do
        local ok, w = pcall(function() return GUIManager:getWindowByName(name) end)
        if ok and w then
            pcall(function() 
                w:SetVisible(true) 
                    w:SetTouchable(false)
                    w:SetXPosition({-9999, -9999})
                    w:SetYPosition({-9999,-9999})
                    w:SetLevel(0)
            end)
            count = count + 1
        end
    end
    if count==4 then DaAnBangThongBaoKetQua=true end
end

nvTruoc=0
itemTruoc=0
metaTruoc=0
function okngay()
    NhiemVu = checkNV()
    if checkNV().id==nvTruoc and itemTruoc==checkNV().itemNV and metaTruoc==checkNV().meta then doneeeeeeeeeeeeee() TraVaoRuong(NhiemVu.itemNV, NhiemVu.meta) return end
    nvTruoc=checkNV().id
    itemTruoc=checkNV().itemNV
    metaTruoc=checkNV().meta
    du, thieu = checkItem(NhiemVu.itemNV, NhiemVu.can, NhiemVu.meta)
    if LayTuRuong(NhiemVu.itemNV, NhiemVu.meta) then
        doneeeeeeeeeeeeee()
        LuaTimer:scheduleTimer(function()
            TraVaoRuong(NhiemVu.itemNV, NhiemVu.meta)
        end, 50, 5)
        return 
    end
    if goodsIdList[NhiemVu.itemNV] then
        MUA(NhiemVu.itemNV, thieu, NhiemVu.meta)
    elseif craftList[NhiemVu.itemNV] then
        MUA(craftList[NhiemVu.itemNV][1], thieu * 9, 0)
        CHETAO(NhiemVu.itemNV, thieu)
    end
    doneeeeeeeeeeeeee()
end
LuaTimer:scheduleTimer(okngay, 100, -1)

