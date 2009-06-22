-----------------------------------------------
-- particleflow instancer v1.0
-- tuomas jomppanen (20.10.2005)
-- www.jomppanen.com
-----------------------------------------------

rollout ParticleInstancer "PFlow Instancer" (

        fn pflow_filt obj = classof obj == PF_Source

        local selectedParticleFlow
        local nofParticleCount
       
        listbox objectInScene "Objects:" width:140 items:(for o in geometry collect o.name) across:3
        button addButton "Add >>" pos:[160,40] width:70
        button removeButton "<< Remove" pos:[160,80] width:70
        listbox objectToDraw "Use:" width:140 pos:[240,0]
       
        groupBox pflowGroup "Particle Flow" width:150 pos:[5,175] height:75
        groupBox instanceGroup "Instance" width:220 pos:[170,175] height:75
        pickbutton pflowSelect "Select PFlow" filter:pflow_filt pos:[40,195]
        label nofParticlesLabel "Particles:" across:2 width:50 pos:[40,225]
        edittext nofParticles readOnly:true width:50 pos:[80,225]
               
        button instanceButton "Instance Selected" width:150 enabled:false pos:[205,220]
        label prefixTextLabel "Instance prefix:" pos:[180,197]
        edittext prefixText readOnly:false pos:[255,195] width:100
       
	   	label aboutLine "Particle Flow Instancer v1.0 - by Tuomas Jomppanen - www.jomppanen.com" pos:[15,260]
	   
        fn checkInstancebutton = (
                if (objectToDraw.items.count > 0 and prefixText.text.count > 0) then (
                        instanceButton.enabled = true
                ) else
                        instanceButton.enabled = false
        )
        on prefixText changed arg do (
                checkInstanceButton()
        )
        on addButton pressed do (
                selectPos = objectInScene.selection
                objName = objectInScene.items[selectPos]
                temp_array = objectToDraw.items
                insertItem (objName) temp_array 1
                objectToDraw.items = temp_array
                checkInstanceButton()
        )
        on objectInScene doubleClicked selected do (
                selectPos = selected
                objName = objectInScene.items[selectPos]
                temp_array = objectToDraw.items
                insertItem (objName) temp_array 1
                objectToDraw.items = temp_array
                checkInstanceButton()
        )
        on objectToDraw doubleClicked selected do (
                if objectToDraw.items.count > 0 and selected > 0 then (

                        objectToDraw.items = deleteItem objectToDraw.items selected

                )
                checkInstanceButton()
        )
       
        on removeButton pressed do (

                if objectToDraw.items.count > 0 and objectToDraw.selection > 0 then (

                        objectToDraw.items = deleteItem objectToDraw.items objectToDraw.selection

                )
                checkInstanceButton()
        )


        on pflowSelect picked obj do (

                viewport = obj.Quantity_Viewport / 100
                print viewport
               
                num = obj.NumParticles() / viewport
                selectedParticleFlow = obj
                nofParticleCount = num as integer
                nofParticles.text = nofParticleCount as string

                pflowSelect.text = obj.name   
        )
        on instancebutton pressed do (
                if(selectedParticleFlow != undefined) do (
                        obj = selectedParticleFlow
                        undo on (
                                for i in 1 to nofParticleCount do (
                                        randItem = mod i objectToDraw.items.count
                                        objName = objectToDraw.items[randItem+1]
                                        objPtr = getNodeByName objName
                                        oInst = instance objPtr
                                       
                                        obj.particleIndex = i
                                        oInst.name = prefixText.text + i as string
                                        oInst.transform = obj.ParticleTM
                       
                                )
               
                        )
                )
        )
)

createDialog ParticleInstancer 400 280